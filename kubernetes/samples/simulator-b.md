# Linux Foundation CKA Simulator B Answers

## Q1

Review: https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/

<namespace>.svc.cluster.local
kubernetes.default.svc.cluster.local
department.lima-workload.svc.cluster.local
hostname.my-svc.my-namespace.svc.cluster-domain.example
section100.section.lima-workload.svc.cluster.local
<pod-ipv4-address>.<service-name>.<my-namespace>.svc.<cluster-domain.example>
1-2-3-4.kube-system.svc.cluster.local
REMINDER: Change IP periods into dashes for cluster DNS names.


## Q2

Review:
* https://kubernetes.io/docs/tasks/configure-pod-container/static-pod/#configuration-files
* https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/

```shell
cat <<TXT | sudo tee /etc/kubernetes/manifests/my-static-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-static-pod
  labels:
    app: static-pod
spec:
  containers:
    - name: web
      image: nginx:1-alpine
      resources:
        requests:
            memory: "20Mi"
            cpu: "10m"
TXT

cat <<TXT | tee my-static-pod-service.yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: static-pod-service
  name: static-pod-service
spec:
  ports:
  - name: "80"
    port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: static-pod
  type: NodePort

TXT

k apply -f my-static-pod-service.yaml

k run -it --rm tester --image nginx -- sh
curl http://static-pod-service.default.svc.cluster.local
```

## Q3

Review: https://kubernetes.io/docs/reference/access-authn-authz/kubelet-tls-bootstrapping/#client-and-serving-certificates

```shell
cat <<TXT | tee /opt/course/3/certificate-info.txt
CN = kubernetes
TLS Web Client Authentication
CN = cka5248-node1-ca@1772658908
TLS Web Server Authentication
TXT

```

## Q4

```shell
k run ready-if-service-ready --image nginx:1-alpine


cat <<TXT | tee q5-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: ready-if-service-ready
  name: ready-if-service-ready
spec:
  containers:
  - name: liveness
    image: nginx:1-alpine
    livenessProbe:
      exec:
        command:
        - "true"
      initialDelaySeconds: 5
      periodSeconds: 5
    readinessProbe:
      exec:
        command:
        - wget
        - -T2
        - -O-
        - http://service-am-i-ready:80 
      initialDelaySeconds: 5
      periodSeconds: 5

TXT

k run am-i-ready --image nginx:1-alpine -l "id=cross-server-ready"
```


## Q5

```shell
cat <<TXT | tee /opt/course/5/find_pods.sh
#!/bin/sh
kubectl get pods -A --sort-by=.metadata.creationTimestamp
TXT

cat <<TXT | tee /opt/course/5/find_pods_uid.sh
#!/bin/sh
kubectl get pods -A --sort-by=.metadata.uid
TXT
```

## Q6

Fix kubelet
```shell
# fix the 203 exit error, in this case the config had the wrong exec path for the `kubelet`
sudo vi /usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf

k run success --image nginx:1-alpine
```
## Q7

Review:
* https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/#backing-up-an-etcd-cluster


```shell
export ENDPOINT=
ETCDCTL_API=3 etcdctl --endpoints $ENDPOINT snapshot save snapshot.db

export ETCDCTL_API=3
sudo  etcdctl --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  snapshot save /opt/course/7/etcd-snapshot.db


# test the snapshot.
sudo etcdutl --write-out=table snapshot status /opt/course/7/etcd-snapshot.db
```

## Q8

```shell
cat <<TXT | tee /opt/course/8/controlplane-components.txt
kubelet: process
kube-apiserver: static-pod
kube-scheduler: static-pod
kube-controller-manager: static-pod
etcd: static-pod
dns: pod coredns
TXT
```

## Q9

Review:

* https://kubernetes.io/docs/concepts/scheduling-eviction/kube-scheduler/

```shell
# Stop the static kube-scheduler
sudo cp /etc/kubernetes/manifests/kube-scheduler.yaml .
sudo rm /etc/kubernetes/manifests/kube-scheduler.yaml

# deploy a single Pod
k run manual-schedule --image httpd:2-alpine
k run manual-schedule --image httpd:2-alpine --dry-run=client -o yaml | tee q9-po.yaml


# manually schedule the Pod
cat <<TXT | tee q9-po.yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: manual-schedule
  name: manual-schedule
spec:
  containers:
  - image: httpd:2-alpine
    name: manual-schedule
  nodeName: cka5248
TXT

k apply -f q9-po.yaml


k run manual-schedule2 --image httpd:2-alpine
```

## Q10

Review:
* https://kubernetes.io/docs/concepts/storage/storage-classes/#storageclass-objects

```shell
cat <<TXT | tee sc.yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-backup
provisioner: rancher.io/local-path
volumeBindingMode: WaitForFirstConsumer
reclaimPolicy: Retain
TXT
k apply -f sc.yaml

cat <<TXT | tee q10-job.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: local-backup
  namespace: project-bern
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: local-backup
  resources:
    requests:
      storage: 50Mi
---
apiVersion: batch/v1
kind: Job
metadata:
  name: backup
  namespace: project-bern
spec:
  backoffLimit: 0
  template:
    spec:
      volumes:
        - name: backup
          persistentVolumeClaim:
            claimName: local-backup
      containers:
        - name: bash
          image: bash:5
          command:
            - bash
            - -c
            - |
              set -x
              touch /backup/backup-$(date +%Y-%m-%d-%H-%M-%S).tar.gz
              sleep 15
          volumeMounts:
            - name: backup
              mountPath: /backup
      restartPolicy: Never

TXT

k apply -f q10-job.yaml
```

## Q11

Review:
* https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#project-secret-keys-to-specific-file-paths
* https://kubernetes.io/docs/reference/kubectl/generated/kubectl_create/kubectl_create_secret_generic/#options

```shell
kubectl create namespace secret
# make secret and mount as readonly in pod
cp /opt/course/11/secret1.yaml .

# edit to set the namespace then apply
k apply -f secret1.yaml

# make a new secret2
kubectl create secret generic secret2 -n secret --from-literal='user=user1' --from-literal='pass=1234'

# generate a pod manifest to modify.
k run secret-pod --image busybox:1 --dry-run=client 

cat <<TXT | tee q11-po.yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: secret-pod
  name: secret-pod
  namespace: secret
spec:
  containers:
  - image: busybox:1
    name: secret-pod
    command:
     - "sleep"
     - "1d"
    volumeMounts:
    - name: vol-secret1
      mountPath: "/tmp/secret1"
      readOnly: true
    env:
    - name: APP_USER
      valueFrom:
        secretKeyRef:
          name: secret2
          key: user
    - name: APP_PASS
      valueFrom:
        secretKeyRef:
          name: secret2
          key: pass
  volumes:
  - name: vol-secret1
    secret:
      secretName: secret1

TXT

k apply -f q11-po.yaml

```

## Q12

Review:

* https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/#concepts
* https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity

Only schedule node on control plane,
it has to tolerate taint: `node-role.kubernetes.io/control-plane:NoSchedule`

```shell
k get po -n kube-system -o wide
k get nodes -o wide

k run -n default pod1-container --image=httpd:2-alpine --dry-run=client -o yaml

cat <<TXT | tee q12-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: pod1-container
  name: pod1
spec:
  containers:
  - image: httpd:2-alpine
    name: pod1-container
  nodeSelector:
    node-role.kubernetes.io/control-plane: ""
  tolerations:
  - key: "node-role.kubernetes.io/control-plane"
    operator: "Exists"
    effect: "NoSchedule"
TXT

k apply -f  q12-pod.yaml

```

## Q13

Review:
* Kubernetes [downward API]()
* https://kubernetes.io/docs/tasks/inject-data-application/environment-variable-expose-pod-information/
* https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#run-a-command-in-a-shell
* https://kubernetes.io/docs/concepts/storage/ephemeral-volumes/
* https://kubernetes.io/docs/concepts/storage/ephemeral-storage/
```shell

cat <<TXT | tee q13-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: multi-container-playground
  name: multi-container-playground
  namespace: default
spec:
  containers:
  - image: nginx:1-alpine
    name: c1
    env:
    - name: MY_NODE_NAME
      valueFrom:
        fieldRef:
          fieldPath: spec.nodeName
    volumeMounts:
    - name: ephemeral
      mountPath: "/your/vol/path/"
  - image: busybox:1
    name: c2
    command: ["/bin/sh"]
    args: ["-c", "while true; do date >> /your/vol/path/date.log; sleep 1; done"]
    volumeMounts:
    - name: ephemeral
      mountPath: "/your/vol/path/"
  - image: busybox:1
    name: c3
    command: ["/bin/sh"]
    args: ["-c", "tail -f /your/vol/path/date.log"]
    volumeMounts:
    - name: ephemeral
      mountPath: "/your/vol/path/"
  volumes:
  - name: ephemeral
    emptyDir:
      sizeLimit: 500Mi

TXT

k apply -f  q13-pod.yaml
```

## Q14

```shell
cat <<TXT | tee /opt/course/14/cluster-info
1: 1
2: 0
3: 10.96.0.0/12
4: weave-net /etc/cni/net.d/10-weave.conflist
5: -cka8448
TXT
```

## Q15

Review: https://kubernetes.io/docs/reference/kubectl/generated/kubectl_events/

```shell
cat <<TXT | tee /opt/course/15/cluster_events.sh
#!/bin/sh
kubectl get events -A --sort-by metadata.creationTimestamp
TXT
chmod +x /opt/course/15/cluster_events.sh

kubectl events -n kube-system --watch | tee pod_kill.log
# modify the output to only contain the kube-proxy kill and whaterever after.
cat pod_kill.log > /opt/course/15/pod_kill.log
kubectl events -n kube-system --for pod/kube-proxy-97tvc --watch | tee /opt/course/15/container_kill.log
```

## Q16

```shell
kubectl api-resources --namespaced=true -o name > resources.txt
rm -f /opt/course/16/resources.txt
while read resource_type
do
    resource_name="$(kubectl get "${resource_type}" -A --no-headers -o name 2> /dev/null)"
    if [ "$?" = "0" ]; then
        echo "${resource_name}" | tee -a /opt/course/16/resources.txt
    else
        echo "skipping resource type ${resource_type}"
    fi
done < resources.txt


k get namespaces | grep project > projects.txt
echo "" > /opt/course/16/resources.txt
roles=0
biggest=0
proj=""
while read name status days
do
    roles="$(k get roles -n "${name}" --no-headers | wc -l)"
    echo "project ${name} has ${roles} roles"
    if [ "${roles}" -gt "${biggest}" ]; then
        biggest=${roles}
        proj="${name}"
    fi
done < projects.txt

printf "%s\n%s\n" "${proj}" "${biggest}" | tee /opt/course/16/crowded-namespace.txt
```

## Q17

Review:

```shell
cat <<TXT | tee q17-student.yaml
apiVersion: education.killer.sh/v1
kind: Student
metadata:
  name: student4
  namespace: operator-prod
spec:
  description: An unidentified person
  name: John Doe
TXT

k apply -f q17-student.yaml