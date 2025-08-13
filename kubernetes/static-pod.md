# Static Pod

A Pod made by placing a Pod manifest in the directory specified in the
`kubelet` configuration option `staticPodPath`, which is usually set to
the `/etc/kubernetes/manifests` directory.

Can only be deleted by removing the Pod manifest file from the configured
directory.

These manifest are then picked up and launched by the `kubelet`.

This Pod type is used to deploy the control plane components on a node; which
is responsible for bringing up each control plane in the cluster. For this
reason the `kubelet` must run as a service on the control plane and not as a
Pod in the cluster.
