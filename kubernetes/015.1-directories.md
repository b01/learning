# Directories

All about the directories where Kubernetes, at the time of writing, places/looks
for files. Knowing the standard locations where files are located is
critical to troubleshooting.

These directories were extracted from a `kubeadm` default setup. But remember
that these can be placed anywhere an admin wants. The standards are loose out
there in the real world. These should give you a general idea where to look for
files when you need to.

| Directories/Files/Package | Purpose                                                                                  |
|---------------------------|------------------------------------------------------------------------------------------|
| /usr/local/bin            | Contains many executables for cluster components that were manually installed.           |
| /opt/cni/bin/             | Contains CNI plugins.                                                                    |
| /etc/cni/net.d            | Contains CNI plugins configurations.                                                     |
| /etc/containerd           | Contains containerd configuration.                                                       |
| /var/run/containerd       | Default location for the containerd.sock.                                                |
| /etc/kubernetes/          | Contains  *.conf cluster access configurations, for example controller-manager.          |
| /etc/kubernetes/manifests | Contains *.yaml static Pods configurations, for example etcd or kube-apiserver.          |
| /etc/kubernetes/pki       | Contains the cluster certificate authority and any component keys and self-signed certs. |
| /etc/kubernetes/pki/etcd  | Certificates for etcd, a directory makes it easy to map just those certs to a container. |
| /var/lib/etcd             | Etcd data directory.                                                                     |
| /var/lib/kube-proxy       | Where you can find the kube-proxy kube config for access the cluster                     |
| /etc/systemd/system       | Where you can place systemd *.service files,                                             |
| kubeadm                   | Installs the /usr/bin/kubeadm CLI tool and the kubelet drop-in file for the kubelet.     |
| kubelet                   | Installs the /usr/bin/kubelet binary.                                                    |
| kubectl                   | Installs the /usr/bin/kubectl binary.                                                    |
| cri-tools                 | Installs the /usr/bin/crictl binary from the cri-tools git repository.                   |
| kubernetes-cni            | Installs the /opt/cni/bin binaries from the plugins git repository                       |
