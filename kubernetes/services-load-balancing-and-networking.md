# Services, Load Balancing, and Networking

Concepts and resources behind networking in Kubernetes.

## Ingress

Ingress exposes HTTP and HTTPS routes from outside the cluster to services
within the cluster. Traffic routing is controlled by rules defined on the
Ingress resource.

Ingress resource only supports rules for directing HTTP(S) traffic.

Review the [service-networking-ingress.yaml] example. You can find it by
searching the kubernetes docs for "**_The Ingress resource_**".


## Resources

* [Services, Load Balancing, and Networking]

---

[Services, Load Balancing, and Networking]: https://kubernetes.io/docs/concepts/services-networking/
[service-networking-ingress.yaml](samples/service-networking-ingress.yaml)
