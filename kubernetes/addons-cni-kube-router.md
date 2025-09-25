# Addon CNI Kube-Router

After trying Flannel, it was time to move on to something that supported the
Kubernetes Network Policy feature. I tried Calico, which is ton of yaml (over
10K lines) and complex to configure. Then pivoting to Antrea, which is less
complex, but just as difficult to configure as Calico. I began looking for
another, then I ran in to Kube-Router. So here we are. Its documentation
is simple, clear, and a quick read. Also the configuration looks as simple
as the standard Kubernetes components, its like it fits right on. Unlike some
others (looking at you Calico and Antrea).

## Requirements

See [Requirements] for more details.

1. Kube-router need to access kubernetes API server to get information on pods,
   services, endpoints, network policies etc.
   ```shell
   read IPV4 IPV6 <<< "$(hostname -I)"
   kube-router --master=https://${IPV4}:6443` or `kube-router --kubeconfig=/etc/kubernetes/kube-router.conf
   ```
   kube-router:
   ```yaml
   
   ```
2. When run as `DaemonSet`, the container image is prepackaged with `ipset`.
   As service/agent on the node, `ipset` package must be installed
   on each node.

   ```shell
   sudo apt install -y ipset ipvsadm
   ```
3. For pod-to-pod network connectivity set the `controller manager` flags to
   allocate pod CIDRs by passing` --allocate-node-cidrs=true` and providing
   cluster CIDRs, such as `--cluster-cidr=10.244.0.0/16,2001:db8:42:0::/56`.
   Must be configured to use CNI network plugins. On each node CNI conf file is
   expected to be present as `/etc/cni/net.d/10-kuberouter.conf` `bridge` CNI
   plugin and `host-local` for IPAM should be used. If you use `hostPort`'s on
   any of your pods, you'll need to install the `hostport` CNI plugin.
   
   NOTE: This will be provided by the `DaemonSet`.
   ```shell
   wget -O /etc/cni/net.d/10-kuberouter.conf https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/cni/10-kuberouter.conf
   ```
   or
   ```text
   {
     "cniVersion": "0.3.0",
     "name":"mynet",
     "type":"bridge",
     "bridge":"kube-bridge",
     "isDefaultGateway":true,
     "ipam": {
        "type":"host-local"
     }
   }
   ```
4. In later than 1.15 Kubernetes versions, only the `kube-apiserver` must be
   run with `--allow-privileged=true`
5. When run as a `DaemonSet`, keep `netfilter` related userspace host tooling
   like `iptables`, `ipset`, and `ipvsadm` in sync with the versions that are
   distributed by Alpine inside the kube-router container.

## Deploy

1. Make a `Role` and RoleBinding for the kube-router:
   NOTE: This will be provided with the `DaemonSet`.
   ```yaml
   ---
   kind: ClusterRoleBinding
   apiVersion: rbac.authorization.k8s.io/v1
   metadata:
      name: kube-router
   roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: kube-router
   subjects:
   - kind: ServiceAccount
     name: kube-router
     namespace: kube-system
   - kind: User # Add the user to the subject for using with the kubeconfig we generated.
     name: kube-router
     apiGroup: rbac.authorization.k8s.io
      ```
2. Generate a certificate for access the `kube-apiserver`:
   ```shell
   read IP4 IP6 <<< "$(hostname -I)"
   export IPV4=${IP4}
   export IPV6=${IP6}
   envsubst < openssl-kube-router.conf.tmpl > openssl-kube-router.conf
   cert_dir=/etc/kubernetes/pki
   CERT_DAYS=365
   CERT_BITS=2048
   CERT_CONF="openssl-kube-router.conf"
   CLUSTER_NAME=kubernetes
   CLUSTER_ENDPOINT=https://${IPV4}:6443
   i="kube-router"

   sudo mkdir -p ${cert_dir}
   cd ~/certs

   openssl genrsa -out "${i}.key" ${CERT_BITS}

   openssl req -new -key "${i}.key" -sha256 \
    -config "${CERT_CONF}" -section ${i} \
    -out "${i}.csr"

   # sign the CSR with the etcd-ca key.
   sudo openssl x509 -req -days ${CERT_DAYS} -in "${i}.csr" \
    -copy_extensions copyall \
    -sha256 -CA "${cert_dir}/ca.crt" \
    -CAkey "${cert_dir}/ca.key" \
    -CAcreateserial \
    -out "${i}.crt"
   ```
3. Make a kubeconfig for `kube-router` a manifest:
   ```shell
   cd ~/certs
   i="kube-router"
   cert_dir=/etc/kubernetes/pki
   CLUSTER_NAME=kubernetes
   CLUSTER_ENDPOINT=https://${IPV4}:6443

   # Make a kubeconfig for the node adding the cluster.
    sudo kubectl config set-cluster ${CLUSTER_NAME} \
     --certificate-authority=${cert_dir}/ca.crt \
     --embed-certs=true \
     --server=${CLUSTER_ENDPOINT} \
     --kubeconfig=/etc/kubernetes/${i}.conf
    # Add credentials to the kubeconfig.
    sudo kubectl config set-credentials ${i} \
     --client-certificate=${i}.crt \
     --client-key=${i}.key \
     --embed-certs=true \
     --kubeconfig=/etc/kubernetes/${i}.conf
   # Add a context to the cluster.
   sudo kubectl config set-context default \
     --cluster=${CLUSTER_NAME} \
     --user=${i} \
     --kubeconfig=/etc/kubernetes/${i}.conf
   # Set the context to use by default in the kubeconfig.
   sudo kubectl config use-context default \
     --kubeconfig=/etc/kubernetes/${i}.conf
   mkdir -p /var/lib/kube-router
   sudo cp -p /etc/kubernetes/kube-router.conf /var/lib/kube-router/kubeconfig
   ```
4. Make a `kube-router` manifest:
   ```shell
   mkdir ~/manifestscd && cd ~/manifests
   wget -O kube-router-all.yml https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/generic-kuberouter-all-features.yaml

   ```
5. Apply changes to the `kube-router` manifest
   ```text
   wget -O kube-router-all.yml https://raw.githubusercontent.com/cloudnativelabs/kube-router/master/daemonset/generic-kuberouter-all-features.yaml
   CLUSTERCIDR=10.96.0.0/16,2001:db8:42:1::/112 \
   APISERVER=https://control-plane:6443 \
   sh -c 'cat kube-router-all.yml | \
   sed -e "s;%APISERVER%;$APISERVER;g" -e "s;%CLUSTERCIDR%;$CLUSTERCIDR;g"' | \
   kubectl apply -f -

   --enable-cni
   --enable-ipv4
   --enable-ipv6
   --service-cluster-ip-range="10.96.0.0/16"
   --service-cluster-ip-range="2001:db8:42:1::/112"
   ```
6. Apply the manifest `kubectl apply -f kube-router-daemonset.yml`

## Cleanup Configuration

```shell
sudo ctr image pull docker.io/cloudnativelabs/kube-router:latest
sudo ctr run --privileged -t --net-host \
    --mount type=bind,src=/lib/modules,dst=/lib/modules,options=rbind:ro \
    --mount type=bind,src=/run/xtables.lock,dst=/run/xtables.lock,options=rbind:rw \
    docker.io/cloudnativelabs/kube-router:latest kube-router-cleanup /usr/local/bin/kube-router --cleanup-config
```

## Trying Kube-Router As An Alternative To Kube-Proxy

```shell
k exec -it -n kube-system <kube-proxy-pod> -- kube-proxy --cleanup
```
---

[Requirements]: https://www.kube-router.io/docs/user-guide/#requirements
