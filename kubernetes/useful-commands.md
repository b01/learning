# Useful Commands

Get a list of all resource types, along with their short name, version, and kind.

`kubectl api-resources`

To view the logs of a container in a pod.

```shell
k logs <pod-name> -c <container-name>
```

Look up a pod with a particular field:

```shell
kubectl get pods -o json | jq '.items[] | select(.spec.initContainers != null) | .metadata.name'
```


```shell
ETCDCTL_API=3 etcdctl \
    --endpoints=https://192.3.76.3:2379 \
    --cacert=/etc/etcd/pki/ca.pem \
    --cert=/etc/etcd/pki/etcd.pem \
    --key=/etc/etcd/pki/etcd-key.pem \
    member list
```

Save a snapshot
```shell
ETCDCTL_API=3 etcdctl \
    --endpoints=https://192.3.76.10:2379 \
    --cacert=/etc/kubernetes/pki/etcd/ca.crt \
    --cert=/etc/kubernetes/pki/etcd/server.crt \
    --key=/etc/kubernetes/pki/etcd/server.key \
    snapshot save /opt/cluster1.db
```

Restore etcd snapshot taken by etcdctl:
```shell
ETCDCTL_API=3 etcdctl \
    --data-dir=/var/lib/etcd-data-new \
    snapshot restore /opt/cluster2.db
```

View the KubeConfig
```shell
k config view
```

```shell
k config use-context <name-a-context>
```

Set an alias:

```yaml
alias k=kubectl
```

Find what CNI Plugin is used: `ls -la /etc/cni/net.d/##-name.*`
NOTE: THere is missing info here, but in all the labs there was only 1.

Get the CIDR of the nodes in the cluster or PODs: `ip addr show`
NOTE: Look for the interface that the internal IP of the controlplane node is tied to. For PODs look for the CNI plugin.


Get CIDR of IP addresses configured for PODs, once you know which CNI plugin is used to configure then review the logs and look for the value of "ipalloc-range":
```shell
k -n kube-system logs weave-net-jslbd weave | grep ipalloc-range
```

Get IP Range (CIDR) configured for the services within the cluster:
```shell
cat /etc/kubernetes/manifests/kube-apiserver.yaml   | grep cluster-ip-range
```

Get the __type__ of proxy the kube-proxy will use at runtime (since it can be given multiple options at initialization):
```shell
kubectl logs <kube-proxy-pod-name> -n kube-system
```

JSON Path to get context of user aws-user:
```shell
kubectl config view --kubeconfig=my-kubeconfig -o jsonpath="{.contexts[?(@.context.user=='aws-user')].name}" > /opt/outputs/aws-context-name
```

Review kubeadm config, you can look at this config file with: `kubectl -n kube-system get cm kubeadm-config -o yaml`


```shell
k get deploy -n kube-system -o custom-columns=DEPLOYMENT:.metadata.name,CONTAINER_IMAGE:.spec.template.spec.containers[*].image,READY_REPLICAS:.spec.replicas,NAMESPACE:.metadata.namespace --sort-by=.metadata.name
```

Use a different config temporarily
```shell
k get po -A --kubeconfig=/root/CKA/adming.kubeconfig
```

Output the `kubeadm` ClusterConfiguration of an existing cluster:

```shell
kubectl get cm kubeadm-config -n kube-system -o=jsonpath="{.data.ClusterConfiguration}"
```

Generate a cluster admin kubeconfig using kubeadm:

```shell
mkdir -p ~/.kube
# NOTE: The config kubeadm-conf.yaml must exist on the control-plane-01 machine.
ssh vagrant@control-plane-01 sudo kubeadm kubeconfig user --client-name=jump-box --org=kubeadm:cluster-admins --config=kubeadm-conf.yaml | tee -a ~/.kube/config
```

View the certificate signing request:

```shell
openssl req  -noout -text -in ./server.csr
```

View the certificate:

```shell
openssl x509 -noout -text -in ./server.crt

certs="$(ls *.crt)"
for i in ${certs[*]}
do
    echo "processing cert ${i}"
    sudo openssl x509 -noout -text -in /etc/kubernetes/pki/${i} | tee /vagrant/kubeadm-certs-txt/${i}.txt
done
```

If you need to see the state of a control plane Pod or its logs:

```shell
sudo crictl --runtime-endpoint unix:///var/run/containerd/containerd.sock ps -a | grep kube | grep -v pause
sudo crictl --runtime-endpoint unix:///var/run/containerd/containerd.sock logs <CONTAINER_ID>
sudo crictl logs <CONTAINER_ID>
```
