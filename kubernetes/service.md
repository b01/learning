# Service

Is a method for exposing (with a URL) an application that is running as one or
more Pods in your cluster.

In short, The Service API is an abstraction to help you expose groups of Pods
over a network.

You don't need to modify your existing application to place them behind a
Service.

Pods are ephemeral resources, to reduce failure, run them as a deployment and
put them behind a service.

A Service spec should have at least these top-level fields:
* `apiVersion` - set to `v1`
* `kind` - set to `Service`
* `metadata` -  a dictionary which should contain "name" field, to give the
   service a name.
* `spec` - additional information pertaining to the object you indicated in
  the `kind` property, refer to documentation for what attributes to use per
  object. When kind is set to a [ServiceSpec] we can use the property `selector`
  which is a map with any keys you desire/need. Traffic will be routed to pods
  with label keys and values matching this `selector`.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app.kubernetes.io/name: MyApp
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9376
```

This makes a service named "my-service" that continuously scans for a set of
Pods that each listen on TCP port **9376** and are labelled as
**app.kubernetes.io/name=MyApp**

For more details about the source of this documentation, please see [Service].

---

[Service]: https://kubernetes.io/docs/concepts/services-networking/service/
[ServiceSpec]: https://kubernetes.io/docs/reference/kubernetes-api/service-resources/service-v1/#ServiceSpec
