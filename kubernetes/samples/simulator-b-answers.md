# Simulator B

## Q1

kubernetes.default.svc.cluster.local
department.lima-workload.svc.cluster.local
section100.section.lima-workload.svc.cluster.local
1-2-3-4.kube-system.pod.cluster.local

## Q2

```shell
cat <<TXT | tee q2-static-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: my-static-pod
  name: my-static-pod
spec:
  containers:
  - image: nginx:1-alpine
    name: my-static-pod
    resources:
      requests:
        memory: "20Mi"
        cpu: "10m
TXT

sudo cp q2-static-pod.yaml /etc/kubernetes/manifests


kubectl create service nodeport static-pod-service --tcp=80 --dry-run=client -o yaml

cat <<TXT | tee q2-svc.yaml
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
    run: my-static-pod
  type: NodePort
TXT

curl curl 192.168.100.31:31501
```

## Q3

```shell
cat <<TXT | tee /opt/course/3/certificate-info.txt
CN = kubernetes
TLS Web Client Authentication
CN = cka5248-node1@1772658908
TLS Web Server Authentication
TXT
```


## Q4

```shell
cat <<TXT | tee q4-pod1.yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: ready-if-service-ready
  name: ready-if-service-ready
spec:
  containers:
  - image: nginx:1-alpine
    name: server
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

k apply -f q4-pod1.yaml

cat <<TXT | tee q4-pod2.yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    id: cross-server-ready
  name: am-i-ready
spec:
  containers:
  - image: nginx:1-alpine
    name: server
TXT

k apply -f q4-pod2.yaml
```


## Q5

```shell
cat <<TXT | tee /opt/course/5/find_pods.sh
#!/bin/sh
kubectl get po -A --sort-by metadata.creationTimestamp
TXT
chmod +x /opt/course/5/find_pods.sh

```

```shell
cat <<TXT | tee /opt/course/5/find_pods_uid.sh
#!/bin/sh
kubectl get po -A --sort-by metadata.uid
TXT
chmod +x /opt/course/5/find_pods_uid.sh

/opt/course/5/find_pods_uid.sh

```

## Q7

```shell
kubectl exec -it -n kube-system etcd-cka2560 -- etcd --version | tee /opt/course/7/etcd-version

export ETCDCTL_API=3
sudo etcdctl --endpoints=https://127.0.0.1:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key \
  snapshot save /opt/course/7/etcd-snapshot.db

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

```shell
sudo cp /etc/kubernetes/manifests/kube-scheduler.yaml .

sudo rm /etc/kubernetes/manifests/kube-scheduler.yaml

k run manual-schedule --image httpd:2-alpine --dry-run=client -o yaml

cat <<TXT | tee q9-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: manual-schedule
  name: manual-schedule
spec:
  containers:
  - image: httpd:2-alpine
    name: manual-schedule
  nodeName: cka5248
TXT

k delete -f q9-pod.yaml
k apply -f q9-pod.yaml

sudo cp kube-scheduler.yaml /etc/kubernetes/manifests/

cat <<TXT | tee q9-pod2.yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: manual-schedule2
  name: manual-schedule2
spec:
  containers:
  - image: httpd:2-alpine
    name: manual-schedule2
TXT

k apply -f q9-pod2.yaml

```

## Q10

```shell
cat <<TXT | tee q10-sc.yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: local-backup
provisioner: rancher.io/local-path
reclaimPolicy: Retain
volumeBindingMode: WaitForFirstConsumer

TXT

k apply -f q10-sc.yaml
```
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: local-backup
  namespace: project-bern
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  resources:
    requests:
      storage: 50Mi
  storageClassName: local-backup
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


```


## Q11

```shell
k create ns secret
k run secret-pod -n secret --image busybox:1 --dry-run=client -oyaml -- sh sleep 1d


cat <<TXT | tee q11-pod1.yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: secret-pod
  name: secret-pod
  namespace: secret
spec:
  volumes:
  - name: secret-volume
    secret:
      secretName: secret1
  containers:
  - args:
    - sleep
    - 1d
    image: busybox:1
    name: secret-pod
    volumeMounts:
    - name: secret-volume
      readOnly: true
      mountPath: "/tmp/secret1"
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
TXT

k create -n secret secret generic secret2 --from-literal='user=user1' --from-literal='pass=1234'
```

## Q12

```shell
cat <<TXT | tee q12-pod1.yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: pod1
  name: pod1
spec:
  nodeSelector:
    node-role.kubernetes.io/control-plane: ""
  containers:
  - image: httpd:2-alpine
    name: pod1-container
  tolerations:
  - key: "node-role.kubernetes.io/control-plane"
    operator: "Exists"
    effect: "NoSchedule"

TXT

k apply -f q12-pod1.yaml

```

## Q13

```shell
cat <<TXT | tee q13-multi-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: multi-container-playground
  name: multi-container-playground
spec:
  nodeSelector:
    node-role.kubernetes.io/control-plane: ""
  containers:
  - image: nginx:1-alpine
    name: c1
    env:
    - name: MY_NODE_NAME
      valueFrom:
        fieldRef:
          fieldPath: spec.nodeName
    volumeMounts:
    - mountPath: /your/vol/path
      name: cache-volume
  - image: busybox:1
    name: c2
    command: ["bin/sh"]
    args: ["-c", "while true; do date >> /your/vol/path/date.log; sleep 1; done"]
    volumeMounts:
    - mountPath: /your/vol/path
      name: cache-volume
  - image: busybox:1
    name: c3
    command: ["bin/sh"]
    args: ["-c", "tail -f /your/vol/path/date.log"]
    volumeMounts:
    - mountPath: /your/vol/path
      name: cache-volume
  volumes:
  - name: cache-volume
    emptyDir:
      sizeLimit: 500Mi
TXT

k apply -f q13-multi-pod.yaml

```
```shell
cat <<TXT | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: loopy
  name: loopy
spec:
  containers:
  - command: ["/bin/sh"]
    args:
    - "-c"
    - "while true; do echo \"loop\"; done"
    image: alpine:latest
    name: loopy
  dnsPolicy: ClusterFirst
  restartPolicy: Always
TXT
k apply -f loopy.yaml
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

```shell
cat <<TXT | tee /opt/course/15/cluster_events.sh
#!/bin/sh
kubectl get events -A --sort-by metadata.creationTimestamp
TXT

chmod +x /opt/course/15/cluster_events.sh
/opt/course/15/cluster_events.sh

```

## 16

```shell
kubectl api-resources -o name > resource-types.txt
rm -rf /opt/course/16/resources.txt
while read resource_type; do
    resource_name="$(kubectl get "${resource_type}" -A -o name 2> /dev/null)"
    echo "${resource_name}" | tee -a /opt/course/16/resources.txt
done < resource-types.txt


k get ns | grep project | tee projects.txt
num_roles=0
biggest=0
while read project_name status age; do
    num_roles="$(kubectl get roles -n "${project_name}" | wc -l)"
    echo "project "${project_name}" has ${num_roles} roles"
    if [ "${num_roles}" -gt "${biggest}" ]; then
        biggest=${num_roles}
        project="${project_name}" 
    fi
done < projects.txt

echo "${project} ${biggest}" | tee /opt/course/16/crowded-namespace.txt

```


## Q17

```shell
cp -R /opt/course/17/operator .

- apiGroups: [""]
  resources: ["pods", "pods/log"]
  verbs: ["get", "list"]