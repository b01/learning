# Storage

Makes up 10% of the CKA exam.

## Storage Classes

* Provides a way for administrators to describe the classes of storage they
  offer.
* The name of a StorageClass object is significant, and is how users can request
  a particular class.
* Contains the fields `provisioner`, `parameters`, and `reclaimPolicy`, and used
  when a PersistentVolume belonging to the class needs to be dynamically
  provisioned to satisfy a PersistentVolumeClaim (PVC).
* To set a default StorageClass use the annotation
`storageclass.kubernetes.io/is-default-class: "true"`
* Dynamic provisioning can be enabled on a cluster by marking a default
  `StorageClass` and enabling the `DefaultStorageClass` admission controller
  on the API server.
* An example storage class object configuration:

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: low-latency
  annotations:
    storageclass.kubernetes.io/is-default-class: "false"
provisioner: csi-driver.example-vendor.example
reclaimPolicy: Retain # default value is Delete
allowVolumeExpansion: true
mountOptions:
  - discard # this might enable UNMAP / TRIM at the block storage layer
volumeBindingMode: WaitForFirstConsumer
parameters:
  guaranteedReadWriteLatency: "true" # provider-specific
```

Local example:

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-storage
provisioner: kubernetes.io/no-provisioner # indicates that this StorageClass does not support automatic provisioning
volumeBindingMode: WaitForFirstConsumer
```

NOTE: Local volumes do not support dynamic provisioning in Kubernetes 1.33;
      however a StorageClass should still be created to delay volume binding
      until a Pod is actually scheduled to the appropriate node. This is
      specified by the `WaitForFirstConsumer` volume binding mode.

## Volume binding mode

The volumeBindingMode field controls when volume binding and dynamic
provisioning should occur.

* If you choose to use WaitForFirstConsumer, do not use nodeName in the Pod
  spec to specify node affinity. If nodeName is used in this case, the
  scheduler will be bypassed and PVC will remain in pending state. Instead, you
  can use `kubernetes.io/hostname`:
  ```yaml
  spec:
    nodeSelector:
      kubernetes.io/hostname: worker-01
  ```
* When the **WaitForFirstConsumer** volume binding mode is specified in the
  StorageClass object; it is no longer necessary to restrict provisioning to
  specific topologies in most situations. If still required,
  `allowedTopologies` can be specified:
  ```yaml
  allowedTopologies:
    - matchLabelExpressions:
      - key: topology.kubernetes.io/zone
        values:
        - us-central-1a
        - us-central-1b
  ```