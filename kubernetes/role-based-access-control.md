# Role Based Access Control

Kubernetes RBAC is required to make use of roles.

## X509 Client Certificates

The common name of the subject is used as the username for the request.

Client certificates can also indicate a user's group memberships using the
certificate's organization fields.

To grant a user or a group permissions in a cluster, you must use
a RoleBinding or ClusterRoleBinding to bind them to a Role or ClusterRole.

To include multiple group memberships for a user, include multiple organization
fields in the certificate.

## Make A Role

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: developer
  namespace: development
rules:
- apiGroups: [""] #  leave it blank for core group.
  resources: [ "pods" ]
  verbs: [ "list", "get", "create", "update", "delete"]
 ```

## Bind A User to A Role

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: developer-binding
  # to limit a user to a namespace, add that here
subjects:
  - kind: User
    name: jump-box
    apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: developer
  apiGroup: rbac.authorization.k8s.io
```

## References

You'll want to review these resource for a deeper understanding.

* [Default roles and role bindings]

---

[Default roles and role bindings]: https://kubernetes.io/docs/reference/access-authn-authz/rbac/#default-roles-and-role-bindings
