# Taints and Tolerances

Used to set restrictions on what Pod can be scheduled on a node.

Taints are set on nodes and tolerance are set on PODs.

```shell
k taint nodes node-name key=value:taint-effect
```

taint-effect possible values are: NodeSchedule | PreferNoSchedule | NoExecute

```shell
k describe nodes <node-name> | grep Taint
```

To remove a taint from a node, use the same taint command with a minus at the end of the taint you want to remove

```shell
k taint nodes <node-name> <full-taint>-
```

Node Selectors or Affinity
Node affinity types

Node Affinity and Taints work together
Set a PODS affinity to the desired node labels to ensure that PODs is placed on that node.
Taint a node to keep undesired PODs off that node.

---

[Node Labels Populated By The Kubelet: Preset labels]: https://kubernetes.io/docs/reference/node/node-labels/#preset-labels
