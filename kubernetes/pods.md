# Pods

Pod (as in a pod of whales or pea pod) is a group of one or more containers,
with shared storage and network resources, and a specification for how to run
the containers.

Pods are used in two main ways:
* Run a single container.
* Run multiple containers that need to work together, but should be reserved
  for more advanced use cases.

A POD spec required these top-level fields:
* `apiVersion` - can be `v1` or `apps\v1`.
* `kind` - can be set to `Pod`.
* `metadata` - is a dictionary which can only contain "name", and "labels",
  labels can be a map with any keys you desire/need.
* `spec` - is additional information pertaining to the object you indicated in
  the `kind` property, refer to documentation for what attributes to use per
  object. For a POD we can use the property `containers` which is list/array,
  each item in the list is a dictionary, so we can add a `name` and `image`
  to set the nginx image for the container.

```yaml
# pod-definition.yml
apiVersion: v1
kind: Pod
metadata:
  name: frontend
  labels:
    kind: website
    type: static
    format: html
spec:
  containers:
    - name: my-fav-anime
      image: nginx:latest
      ports:
        - containerPort: 8080
```

## Useful Commands

Make an alias to `kubectl` on Mac/Linux.
`alias k='kubectl'`

List Pods in all namespaces.
`k get pods -A`

Dump a Pods definition in YAML format.
`k get pod <name> -n <namespace> -o yaml`

Quickly run a Pod, useful for testing and when taking an exam.
`k run nginx --image nginx`

Display more info about pods.
`k get pods -n <namespace> -o wide`

Quickly generate a Pod specification without deploying the Pod.
`k run redis --image redis123 --dry-run=client -o yaml`