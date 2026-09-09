#!/bin/sh

set -e

mkdir -p ~/certs && cd ~/certs
cp /vagrant/openssl-* .

getIps () {
  iface=${1}
  export IPV4=$(ip -4 addr show scope global dev ${iface} | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
  export IPV6=$(ip -6 addr show scope global dev ${iface} | grep "inet6\b" | awk '{print $2}' | cut -d/ -f1)
}

etcd_certs=("healthcheck-client" "peer" "server")
etcd_cert_dir=/etc/kubernetes/pki/etcd
CERT_DAYS=365
CERT_BITS=2048
ETCD_CERT_CONF="openssl-etcd.conf"

getIps "enp0s8"
envsubst < openssl-etcd.conf.tmpl > ${ETCD_CERT_CONF}

sudo mkdir -p ${etcd_cert_dir}

# Generate the etcd CA key.
sudo openssl genrsa -out "${etcd_cert_dir}/ca.key" ${CERT_BITS}

# Generate the etcd CA certificate.
sudo openssl req -x509 -new -sha256 -noenc \
    -key "${etcd_cert_dir}/ca.key" -days ${CERT_DAYS} \
    -config ${ETCD_CERT_CONF} -section etcd \
    -out "${etcd_cert_dir}/ca.crt"

# Generate the etcd server, clients, and heath-check keys and certs.
for i in ${etcd_certs[*]}; do
  sudo openssl genrsa -out "${etcd_cert_dir}/${i}.key" ${CERT_BITS}

  sudo openssl req -new -key "${etcd_cert_dir}/${i}.key" -sha256 \
    -config "${ETCD_CERT_CONF}" -section ${i} \
    -out "${i}.csr"

  sudo openssl x509 -req -days ${CERT_DAYS} -in "${i}.csr" \
    -copy_extensions copyall \
    -sha256 -CA "${etcd_cert_dir}/ca.crt" \
    -CAkey "${etcd_cert_dir}/ca.key" \
    -CAcreateserial \
    -out "${etcd_cert_dir}/${i}.crt"
done

# remove the openssl serial no. count increment file.
sudo rm -rf /etc/kubernetes/pki/etcd/ca.srl

cert_dir=/etc/kubernetes/pki
CLUSTER_CN=kubernetes
CERT_CONF="openssl-control-plane.conf"
CLUSTER_NAME=kubernetes
CLUSTER_ENDPOINT=https://${IPV6}:6443

envsubst < openssl-control-plane.conf.tmpl > openssl-control-plane.conf
sudo mkdir -p ${cert_dir}

sudo openssl genrsa -out "${cert_dir}/ca.key" ${CERT_BITS}
sudo openssl req -x509 -new -nodes \
    -key "${cert_dir}/ca.key" \
    -subj "/CN=${CLUSTER_CN}" \
    -days ${CERT_DAYS} -out "${cert_dir}/ca.crt"

certificates=("apiserver" "apiserver-kubelet-client")
for i in ${certificates[*]}
do
    sudo openssl genrsa -out "${cert_dir}/${i}.key" ${CERT_BITS}
    # Make a Certificate Signing Request
    sudo openssl req -new -key "${cert_dir}/${i}.key" -sha256 \
         -config "${CERT_CONF}" -section ${i} \
         -out "${i}.csr"
    # Sign the CSR with the kubernetes-ca.
    sudo openssl x509 -req -days ${CERT_DAYS} -in "${i}.csr" \
         -copy_extensions copyall \
         -sha256 -CA "${cert_dir}/ca.crt" \
         -CAkey "${cert_dir}/ca.key" \
         -CAcreateserial \
         -out "${cert_dir}/${i}.crt"
done

sudo openssl genrsa -out "${cert_dir}/sa.key" ${CERT_BITS}
sudo openssl rsa -pubout -in "${cert_dir}/sa.key" -out "${cert_dir}/sa.pub"

i="front-proxy-ca"
sudo openssl genrsa -out "${cert_dir}/${i}.key" ${CERT_BITS}
sudo openssl req -x509 -new -key "${cert_dir}/${i}.key" \
    -config "${CERT_CONF}" -section ${i} \
    -out "${cert_dir}/${i}.crt"

i="front-proxy-client"
sudo openssl genrsa -out "${cert_dir}/${i}.key" ${CERT_BITS}

sudo openssl req -new -key "${cert_dir}/${i}.key" -sha256 \
-config "${CERT_CONF}" -section ${i} \
-out "${i}.csr"

sudo openssl x509 -req -days ${CERT_DAYS} -in "${i}.csr" \
-copy_extensions copyall \
-CAkey "${cert_dir}/front-proxy-ca.key" \
-sha256 -CA "${cert_dir}/front-proxy-ca.crt" \
-CAcreateserial \
-out "${cert_dir}/${i}.crt"
# cleanup
sudo rm -rf "${cert_dir}"/*.srl

# Generate certificate for control-plane components
configs=("controller-manager" "scheduler" "kube-proxy" "admin" "super-admin")
for i in ${configs[*]}
do
   sudo openssl genrsa -out "${i}.key" ${CERT_BITS}

   sudo openssl req -new -key "${i}.key" -sha256 \
   -config "${CERT_CONF}" -section ${i} \
   -out "${i}.csr"

   sudo openssl x509 -req -days ${CERT_DAYS} -in "${i}.csr" \
   -copy_extensions copyall \
   -CAkey "${cert_dir}/ca.key" \
   -sha256 -CA "${cert_dir}/ca.crt" \
   -CAcreateserial \
   -out "${i}.crt"
done

i="apiserver-etcd-client"

sudo openssl genrsa -out "${cert_dir}/${i}.key" ${CERT_BITS}

sudo openssl req -new -key "${cert_dir}/${i}.key" -sha256 \
 -config "${CERT_CONF}" -section ${i} \
 -out "${i}.csr"

# sign the CSR with the etcd-ca key.
sudo openssl x509 -req -days ${CERT_DAYS} -in "${i}.csr" \
 -copy_extensions copyall \
 -sha256 -CA "${etcd_cert_dir}/ca.crt" \
 -CAkey "${etcd_cert_dir}/ca.key" \
 -CAcreateserial \
 -out "${cert_dir}/${i}.crt"

cat <<TXT | tee machines.txt
control-plane-01 192.168.56.11 2000:192:168:56::11
worker-01        192.168.56.21 2000:192:168:56::21
worker-02        192.168.56.22 2000:192:168:56::22
TXT

KUBELET_CONF="openssl-kubelet.conf"

while read NODE_NAME NODE_IPV4 NODE_IPV6
do
    # generate a key
    sudo openssl genrsa -out "${NODE_NAME}.key" ${CERT_BITS}
    # generate a new kubelet OpenSSL configuration.
    export NODE_NAME=${NODE_NAME}
    export NODE_IPV4=${NODE_IPV4}
    export NODE_IPV6=${NODE_IPV6}
    envsubst < openssl-kubelet.conf.tmpl > openssl-kubelet.conf
    # make a CSR
    sudo openssl req -new -key "${NODE_NAME}.key" -sha256 \
      -config "${KUBELET_CONF}" -section "node" \
      -out "${NODE_NAME}.csr"
    # Use the cluster CA to sign the CSR and make a certificate.
    sudo openssl x509 -req -days ${CERT_DAYS} -in "${NODE_NAME}.csr" \
       -copy_extensions copyall \
       -CAkey "${cert_dir}/ca.key" \
       -sha256 -CA "${cert_dir}/ca.crt" \
       -CAcreateserial \
       -out "${NODE_NAME}.crt"
done < machines.txt

gen_kubeconfig() {
   i="${1}"
   user_name="${2}"
   sudo kubectl config set-cluster ${CLUSTER_NAME} \
        --certificate-authority=${cert_dir}/ca.crt \
        --embed-certs=true \
        --server=${CLUSTER_ENDPOINT} \
        --kubeconfig=/etc/kubernetes/${i}.conf

   sudo kubectl config set-credentials ${user_name} \
        --client-certificate=${i}.crt \
        --client-key=${i}.key \
        --embed-certs=true \
        --kubeconfig=/etc/kubernetes/${i}.conf

   sudo kubectl config set-context default \
        --cluster=${CLUSTER_NAME} \
        --user=${user_name} \
        --kubeconfig=/etc/kubernetes/${i}.conf

   sudo kubectl config use-context default \
        --kubeconfig=/etc/kubernetes/${i}.conf
}

gen_kubeconfig "controller-manager" "default-controller-manager"
gen_kubeconfig "scheduler" "default-scheduler"
gen_kubeconfig "kube-proxy" "system:kube-proxy"
gen_kubeconfig "admin" "default-admin"
gen_kubeconfig "super-admin" "default-super-admin"

nodes=("control-plane-01" "worker-01" "worker-02")
for i in ${nodes[*]}
do
   if [ -f "${i}.key" ]; then
    # Make a kubeconfig for the node adding the cluster.
    sudo kubectl config set-cluster ${CLUSTER_NAME} \
     --certificate-authority=${cert_dir}/ca.crt \
     --embed-certs=true \
     --server=${CLUSTER_ENDPOINT} \
     --kubeconfig=${i}.conf
    # Add credentials to the kubeconfig.
    sudo kubectl config set-credentials ${i} \
     --client-certificate=${i}.crt \
     --client-key=${i}.key \
     --embed-certs=true \
     --kubeconfig=${i}.conf
   # Add a context to the cluster.
   sudo kubectl config set-context default \
     --cluster=${CLUSTER_NAME} \
     --user=${i} \
     --kubeconfig=${i}.conf
   # Set the context to use by default in the kubeconfig.
   sudo kubectl config use-context default \
     --kubeconfig=${i}.conf
  fi
done

export ADVERTISE_ADDRESS=${IPV6}
export POD_CIDRS=fd12:3456:789a:1000::/56,10.244.0.0/16
export SERVICE_CIDRS=fd12:3456:789a:2000::/112,10.96.0.0/16
export KUBE_VER=v1.35
export HOSTNAME=$(hostname)

sudo mkdir -p /etc/kubernetes/manifests/
mkdir -p ~/manifests
cd ~/manifests
cp /vagrant/*.yaml.tmpl .

envsubst < etcd.yaml.tmpl | sudo tee /etc/kubernetes/manifests/etcd.yaml
envsubst < kube-apiserver.yaml.tmpl | sudo tee /etc/kubernetes/manifests/kube-apiserver.yaml
envsubst < kube-controller-manager.yaml.tmpl | sudo tee /etc/kubernetes/manifests/kube-controller-manager.yaml
envsubst < kube-scheduler.yaml.tmpl | sudo tee /etc/kubernetes/manifests/kube-scheduler.yaml

# Make a kubelet configuration.
sudo install -m 644 /vagrant/config.yaml /var/lib/kubelet

# Make a systemd service unit configuration for kubelet.
sudo install -d /etc/systemd/system/kubelet.service.d
cat /vagrant/kubelet.service.tmpl | envsubst | tee kubelet.conf
sudo install -m 644 kubelet.conf /etc/systemd/system/kubelet.service.d/kubelet.conf

# Generate a Token authentication file:
BOOTSTRAP_TOKEN="$(head -c 16 /dev/urandom | od -An -t x | tr -d ' ')"
cat <<TXT | sudo tee /etc/kubernetes/bootstrap-token
${BOOTSTRAP_TOKEN},kubelet-bootstrap,10001,"system:bootstrappers"
TXT