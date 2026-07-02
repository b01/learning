#!/bin/sh

set -e

# Update the system and install tools needed
sudo apt update && sudo apt upgrade -y
sudo apt install -y \
   apt-transport-https ca-certificates curl gpg jq openssl wget vim

sudo sed -i 's/\(\/swap\.img.*\)$/#\1/' /etc/fstab
sudo swapoff -a

cat <<TXT | sudo tee -a /etc/modules-load.d/modules.conf
br_netfilter
TXT
sudo modprobe br_netfilter

# Enable for IPv4 and IPv6 (a.k.a dual-stack), then load (with `sysctl -p`) in sysctl settings from the file specified.
cat <<TXT | sudo tee -a /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding = 1
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
TXT

# Load in sysctl settings from the file specified
sudo sysctl -p /etc/sysctl.d/k8s.conf

cat <<TXT | sudo tee -a /etc/hosts

# k8s network
192.168.56.11       control-plane control-plane-01
2000:192:168:56::11 control-plane control-plane-01
192.168.56.21       worker-01
2000:192:168:56::21 worker-01
192.168.56.22       worker-02
2000:192:168:56::22 worker-02
TXT

# Install containerd
ARCH=$(dpkg --print-architecture)
CTND_VER=2.3.2
wget https://github.com/containerd/containerd/releases/download/v${CTND_VER}/containerd-${CTND_VER}-linux-${ARCH}.tar.gz

sudo tar Cxzvf /usr/local containerd-${CTND_VER}-linux-amd64.tar.gz

wget https://raw.githubusercontent.com/containerd/containerd/refs/tags/v${CTND_VER}/containerd.service
sudo install -m 755 containerd.service /etc/systemd/system

# Install runc
wget https://github.com/opencontainers/runc/releases/download/v1.5.0/runc.${ARCH}
sudo install -m 755 runc.${ARCH} /usr/local/sbin/runc

# Install CNI plugins
CNI_VER=1.9.1
wget https://github.com/containernetworking/plugins/releases/download/v${CNI_VER}/cni-plugins-linux-${ARCH}-v${CNI_VER}.tgz
sudo mkdir -p /opt/cni/bin
sudo tar Cxzvf /opt/cni/bin cni-plugins-linux-${ARCH}-v${CNI_VER}.tgz

sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml

sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

#sudo sed -i "s/sandbox = 'registry.k8s.io/pause:.*'/sandbox = 'registry.k8s.io/pause:3.10.1'/" /etc/containerd/config.toml

sudo systemctl daemon-reload
sudo systemctl enable --now containerd

# Install kubernetes packages.

KUBE_VER="1.35"
curl -fsSL https://pkgs.k8s.io/core:/stable:/v${KUBE_VER}/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
cat <<TXT | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v${KUBE_VER}/deb/ /
TXT
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

cp ~/.bashrc bashrc.bak
echo "alias k='kubectl'" | tee -a ~/.bashrc
alias k='kubectl'

# Install crictl tool.
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/v${KUBE_VER}.0/crictl-v${KUBE_VER}.0-linux-amd64.tar.gz
sudo tar Cxzvf /usr/local/bin crictl-v${KUBE_VER}.0-linux-amd64.tar.gz
crictl --version

cat <<TXT | sudo tee -a /etc/crictl.yaml
runtime-endpoint: unix:///var/run/containerd/containerd.sock
image-endpoint: unix:///var/run/containerd/containerd.sock
timeout: 10
TXT
