# Components

# Container Runtime Interface

CRI is a plugin interface which enables the `kubelet` to use a wide variety of
container runtimes; without having a need to recompile the cluster components.

You need a working container runtime on each node in your cluster, so that the
`kubelet` can launch Pods and their containers.

Defines the main [gRPC] protocol for the communication between the node
components `kubelet` and container runtime.

Both the `kubelet` and the underlying container runtime need to interface with
control groups to enforce resource management for Pods and containers and set
resources such as cpu/memory requests and limits. It's critical that the
`kubelet` and the container runtime use the same cgroup driver and are
configured the same.

