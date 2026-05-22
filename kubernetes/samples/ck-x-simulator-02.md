# CK X Simulator

**Core Concepts | Difficulty: Easy**


## Q1 Answer

```shell
k create namespace app-team1
k run --image=nginx:1.19 -n app-team1 nginx-pod
cat <<TXT | k apply -f -
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: nginx-pod
  name: nginx-pod
  namespace: app-team1
spec:
  containers:
  - image: nginx:1.19
    name: nginx-pod
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
TXT
```

## Q2 Answer

```shell
k --dry-run=client -o yaml run --image=nginx:1.19 --port=80 static-web
cat <<TXT | tee /etc/kubernetes/manifests/static-web.yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: static-web
  name: static-web
spec:
  containers:
  - image: nginx:1.19
    name: static-web
    ports:
    - containerPort: 80
  dnsPolicy: ClusterFirst
  restartPolicy: Always
TXT
```

**Review**

* [Create a static pod]


## Q3 Answer

```shell
cat <<TXT | k apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast-storage
provisioner: kubernetes.io/no-provisioner
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: data-pvc
  namespace: storage
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: fast-storage
  resources:
    requests:
      storage: 1Gi
TXT
```

**Review**

* [Enabling Dynamic Provisioning]

## Q4 Answer

```shell
 k --dry-run=client -o yaml run -n monitoring --image=busybox logger -- sh -c "while true; do echo "salam" | tee /
var/log/app.log; sleep 3; done"

cat <<TXT | k apply -f -
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: logger
  name: logger
  namespace: monitoring
spec:
  containers:
  - args:
    - sh
    - -c
    - while true; do echo salam | tee /var/log/app.log; sleep 3; done
    image: busybox
    name: busybox
    volumeMounts:
    - name: log-volume
      mountPath: /var/log
  - image: fluentd
    name: fluentd
    volumeMounts:
    - name: log-volume
      mountPath: /fluentd/log
  dnsPolicy: ClusterFirst
  restartPolicy: Always
  volumes:
  - name: log-volume
    emptyDir: {}
TXT
```

**Review**

* [fluent/fluentd]


## Q5

```shell
k create serviceaccount -n default app-sa
k create role --verb=list --verb=get --resource=pod pod-reader --dry-run=client -o yaml
k create rolebinding -n default --serviceaccount=default:app-sa --role=pod-reader read-pods --dry-run=client -o yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-pods
  namespace: default
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: pod-reader
subjects:
- kind: ServiceAccount
  name: app-sa
  namespace: default
```

## Q6 Answer

```shell
cat <<TXT | k apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: db-policy
  namespace: networking
spec:
  podSelector:
    matchLabels:
      role: db
  ingress:
  - from:
    - podSelector:
        matchLabels:
          role: frontend
    ports:
        - protocol: TCP
          port: 3306
          endPort: 3306
  policyTypes:
  - Ingress
TXT

k -n networking run --image=nginx --dry-run=client -o yaml frontend
k -n networking run --image=nginx --dry-run=client -o yaml db

cat <<TXT | k apply -f -
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: frontend
    role: frontend
  name: frontend
  namespace: networking
spec:
  containers:
  - image: nginx
    name: frontend
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
---
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: db
    role: db
  name: db
  namespace: networking
spec:
  containers:
  - image: nginx
    name: db
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
TXT

k create service nodeport --tcp=80 web-service --dry-run=client -o yaml
cat <<TXT | k apply -f -
apiVersion: v1
kind: Service
metadata:
  labels:
    app: web-service
  name: web-service
spec:
  ports:
  - name: "80"
    port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: web-app
  type: NodePort
TXT
```

## Q8 Answer

```shell
k --dry-run=client -o yaml run --image=nginx -n monitoring resource-pod
cat <<TXT | k apply -f -
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: resource-pod
  name: resource-pod
  namespace: monitoring
spec:
  containers:
  - image: nginx
    name: resource-pod
    resources:
     requests:
       cpu: 100m
       memory: 128Mi
     limits:
       cpu: 200m
       memory: 256Mi
  dnsPolicy: ClusterFirst
  restartPolicy: Always
TXT
```

## Q9

```shell
k --dry-run=client -o yaml create configmap -- APP_COLOR=blue app-config
cat <<TXT | k apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  APP_COLOR: blue
TXT

k --dry-run=client -o yaml run --image=nginx config-pod

cat <<TXT | k apply -f -
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: config-pod
  name: config-pod
spec:
  containers:
  - image: nginx
    name: config-pod
    resources: {}
    volumeMounts:
    - name: config-volume
      mountPath: /etc/config
  dnsPolicy: ClusterFirst
  restartPolicy: Always
  volumes:
  - name: config-volume
    configMap:
      name: app-config
TXT

k exec -it config-pod -- sh
```

## Q10

```shell
cat <<TXT | k apply -f -
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: health-check
  name: health-check
spec:
  containers:
  - image: nginx
    name: health-check
    resources: {}
    livenessProbe:
      httpGet:
        path: /
        port: 80
      initialDelaySeconds: 5
    readinessProbe:
      httpGet:
        path: /
        port: 80
      initialDelaySeconds: 5
  dnsPolicy: ClusterFirst
  restartPolicy: Always
TXT
```

**Review**

* [Liveness, Readiness, and Startup Probes]
* [Configure Liveness, Readiness and Startup Probes]

---

[Create a static pod]: https://kubernetes.io/docs/tasks/configure-pod-container/static-pod/#static-pod-creation
[Enabling Dynamic Provisioning]: https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/
[fluent/fluentd]: https://hub.docker.com/r/fluent/fluentd/
[Liveness, Readiness, and Startup Probes]: https://kubernetes.io/docs/concepts/workloads/pods/probes/
[Configure Liveness, Readiness and Startup Probes]: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/
