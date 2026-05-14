# Pod Security Admission

Enforce the [Pod Security Standards].

Places requirements on a Pod's [Security Context] and related fields according
to the three levels defined by the [Pod Security Standards], which are:
* `privileged` - Unrestricted policy, providing the widest possible level of
  permissions. This policy allows for known privilege escalations.
* `baseline` - Minimally restrictive policy which prevents known privilege
  escalations. Allows the default (minimally specified) Pod configuration.
* `restricted` - Heavily restricted policy, following current Pod hardening
  best practices.

Use labels defined on a namespace to set the admission control mode to use for
pod security; which defines what action the control plane takes if a potential
violation is detected.
```yaml
# MODE must be one of `enforce`, `audit`, or `warn`.
# LEVEL must be one of `privileged`, `baseline`, or `restricted`.
pod-security.kubernetes.io/<MODE>: <LEVEL>
# Optional: per-mode version label that can be used to pin the policy to the
# version that shipped with a given Kubernetes minor version (for example v1.33).
# VERSION must be a valid Kubernetes minor version, or `latest`.
# pod-security.kubernetes.io/<MODE>-version: <VERSION>
```

Pods are often created indirectly, by creating a workload object such as a
Deployment or Job.
To help catch violations early, both the `audit` and `warn` modes are also
applied to the workload resources. However, `enforce` mode is not applied to
workload resources, only to the resulting pod objects.

You can define exemptions from pod security enforcement. Exemption dimensions
include:
* Usernames: requests from users with an exempt authenticated (or impersonated)
  username are ignored.
* RuntimeClassNames: pods and workload resources specifying an exempt runtime
  class name are ignored.
* Namespaces: pods and workload resources in an exempt namespace are ignored.

NOTE: Exempting an end user will only exempt them from enforcement when creating
pods directly.

The following metrics are exposed:

* `pod_security_errors_total` - indicates the number of errors preventing
  normal evaluation. Non-fatal errors may result in the latest restricted
  profile being used for enforcement.
* `pod_security_evaluations_total` - indicates the number of policy evaluations
  that have occurred, not counting ignored or exempt requests during exporting.
* `pod_security_exemptions_total` - indicates the number of exempt requests,
  not counting ignored or out of scope requests.

## Resources

* [Pod Security Standards]
* [Pod Security Admission]
* [Configure the Admission Controller]
* [Enforce Pod Security Standards with Namespace Labels]

---

[Pod Security Standards]: https://kubernetes.io/docs/concepts/security/pod-security-standards/
[Pod Security Admission]: https://kubernetes.io/docs/concepts/security/pod-security-admission/
[Security Context]: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/
[Configure the Admission Controller]: https://kubernetes.io/docs/tasks/configure-pod-container/enforce-standards-admission-controller/#configure-the-admission-controller
[Enforce Pod Security Standards with Namespace Labels]: https://kubernetes.io/docs/tasks/configure-pod-container/enforce-standards-namespace-labels/
