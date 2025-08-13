# Daemon Sets

Makes sure 1 Pod for a given PodSpec is always deployed to every node.

For example, `kube-proxy` is run as a DaemonSet.

DaemonSet generally ignore taints, but with some nuance. They are designed to
run on every eligible node, regardless of taints, unless explicitly restricted.
DaemonSet Pods automatically tolerate certain taints, especially:
- `node.kubernetes.io/not-ready`
- `node.kubernetes.io/unreachable`
- `node.kubernetes.io/disk-pressure`
- `node.kubernetes.io/memory-pressure`
- `node.kubernetes.io/network-unavailable`
- `node.kubernetes.io/unschedulable`

These tolerations are added automatically when it is made.

They don’t ignore custom taints (e.g., key=value:NoSchedule) to a node, and
will not schedule Pods there unless you explicitly add matching tolerations
to the DaemonSetSpec.

So if you're manually tainting nodes for isolation or control, you’ll need to
manually add tolerations to your DaemonSet.

## Useful Commands

Get help generating DaemonSet commands.
`k create deploy --help`

There is no command to generate a DaemonSet Pod manifest directly; Instead make
a Deployment manifest, set the kind to "DaemonSet", then remove the replicas,
strategy, and status fields.
`k create deploy nginx-proxy --image=nginx --dry-run=client -o yaml`
