# Linux Kernel Options

These options affect how the network behaves on a Linux system.

br_netfilter

```shell
sudo modprobe br_netfilter
cat <<TXT | sudo tee /etc/sysctl.d/k8s.conf
TXT
```

`net.ipv4.ip_forward`

`net.ipv6.conf.all.forwarding`
