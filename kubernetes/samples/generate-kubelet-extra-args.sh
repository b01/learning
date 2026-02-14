#!/bin/bash

set -e

dvc="${1}"
# Detect IPv6 (global, non-link-local)
IPV6=$(ip -6 addr show dev "${dvc}" scope global | awk '/inet6/ {print $2}' | cut -d/ -f1)

# Detect IPv4
IPV4=$(ip -4 addr show dev "${dvc}" | awk '/inet / {print $2}' | cut -d/ -f1)

# Write kubelet drop-in
mkdir -p /etc/systemd/system/kubelet.service.d
cat <<EOF >/etc/systemd/system/kubelet.service.d/10-node-ip.conf
[Service]
Environment="KUBELET_EXTRA_ARGS=--node-ip=${IPV6},${IPV4}"
EOF

systemctl daemon-reload
systemctl restart kubelet

# Join the cluster
kubeadm join <your-control-plane>:6443 \
  --token <token> \
  --discovery-token-ca-cert-hash sha256:<hash>