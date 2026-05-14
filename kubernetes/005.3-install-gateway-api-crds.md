# Gateway API

An official Kubernetes project focused on L4 and L7 routing in Kubernetes.

Also see [Introduction] for more details.

## Install

```shell
wget -o gateway-api-crds.yaml https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.4.1/standard-install.yaml

kubectl apply --server-side -f gateway-api-crds.yaml
```

---

[Deploying a simple Gateway]: https://gateway-api.sigs.k8s.io/guides/getting-started/simple-gateway/
[Introduction]: https://gateway-api.sigs.k8s.io/