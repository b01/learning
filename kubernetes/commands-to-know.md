# Commands To Know

This is a list of items to practice and know by heart when administering
Kubernetes.

## Cluster Related

1. Deploy a 3 node cluster to 3 machines
2. Move static pods to another node or save a static pod for brringing it back
   up later.
3. fileAdd a ndeCordon a node
4. Log into a container within a POD.
5. Make a assign cluster and non-cluster role.
6. Make and use a service account.

## Linux

Knowing specific command line tools and how to use them can greatly speed you
up. I'd recommend learning how to perform these task via command line interface
(CLI) in order to save time whenever you need to work with a Kubernetes cluster.

NOTE: Working through [Kubernetes The Hard Way] will show you a glimpse of how
to use these tools.

1. Setup **openssh** server on a machine.
2. Setup SSH for login on a remote machine.
3. Use **ssh-copy-id** to copy an SSH pub key to a remote machine.
4. Use **scp** to copy files and even directories between machines.
5. Use **ssh** to log into a machine and rune commands remotely on a machine.
6. Use **openssl** to make TLS certificates, yes there are tools that can help
   make this faster, learn at least the most popular one to-date as well. This
   is your fallback when you don't have access to that tool.

---

[Kubernetes The Hard Way]: https://github.com/b01/kubernetes-the-hard-way
