# CK-X CKA Simulator Hard Answers

## Q1 Answer

```shell
cat <<TXT | k apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: data-pvc
  namespace: storage-task
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: standard
  resources:
    requests:
      storage: 2Gi
---
apiVersion: v1
kind: Pod
metadata:
  name: data-pod
  namespace: storage-task
spec:
  containers:
    - name: nginx
      image: nginx
      ports:
      - containerPort: 80
      volumeMounts:
      - mountPath: /usr/share/nginx/html
        name: data
  volumes:
  - name: data
    persistentVolumeClaim:
      claimName: data-pvc
TXT
```

**Review**

* [Using Dynamic Provisioning]
* [Claims As Volumes]

## Q2 Answer

```shell
cat <<TXT | k apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: fast-local
  namespace: storage-class
  annotations:
    storageclass.kubernetes.io/is-default-class: "true"
provisioner: rancher.io/local-path
volumeBindingMode: WaitForFirstConsumer
TXT
k -n storage-class sc default-test
# change default to false
k -n storage-class sc edit local-path
# change default to false
```

**Review**

* [StorageClass objects]


## Q3 Answer

```shell
cat <<TXT | k apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: manual-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /mnt/data
  nodeAffinity:
    required:
      nodeSelectorTerms:
      - matchExpressions:
        - key: kubernetes.io/hostname
          operator: In
          values:
          - k3d-cluster-agent-0
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: manual-pvc
  namespace: manual-storage
spec:
  storageClassName: ""
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
TXT

k --dry-run=client -o yaml -n manual-storage run --image=busybox manual-pod -- sleep 3600

cat <<TXT | k apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: manual-pod
  namespace: manual-storage
spec:
  containers:
  - command:
    - "sleep"
    - "3600"
    image: busybox
    name: busybox
    volumeMounts:
    - name: manual-pvc
      mountPath: /data
  dnsPolicy: ClusterFirst
  restartPolicy: Always
  volumes:
  - name: manual-pvc
    persistentVolumeClaim:
      claimName: manual-pvc
TXT
```

**Review**

* [Create a PersistentVolume]
* [Node Affinity]

## Q4 Answer

```shell
k --dry-run=client -o yaml create deployment --image=nginx --replicas=2 scaling-app
cat <<TXT | k apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: scaling-app
  name: scaling-app
  namespace: scaling
spec:
  replicas: 2
  selector:
    matchLabels:
      app: scaling-app
  template:
    metadata:
      labels:
        app: scaling-app
    spec:
      containers:
      - image: nginx
        name: nginx
        resources:
          requests:
            cpu: 200m
            memory: 256Mi
          limits:
            cpu: 500m
            memory: 512Mi
TXT

k --dry-run=client -o yaml autoscale deployment -n scaling scaling-app  --min=2 --max=5
cat <<TXT | k apply -f -
apiVersion: autoscaling/v1
kind: HorizontalPodAutoscaler
metadata:
  name: scaling-app
  namespace: scaling
spec:
  maxReplicas: 5
  minReplicas: 2
  targetCPUUtilizationPercentage: 70
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: scaling-app
TXT
```

## Q5 Answer

```shell
kubectl label nodes k3d-cluster-agent-1 disk=ssd
# or
k edit node k3d-cluster-agent-1

cat <<TXT | k apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: app-scheduling
  name: app-scheduling
  namespace: scheduling
spec:
  replicas: 3
  selector:
    matchLabels:
      app: app-scheduling
  template:
    metadata:
      labels:
        app: app-scheduling
    spec:
      containers:
      - image: nginx
        name: nginx
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: disk
                operator: In
                values:
                - ssd
TXT
```

**Review**

* [Add a label to a node]
* [Operators]

## Q6 Answer

```shell
cat <<TXT | k apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: security
  labels:
    pod-security.kubernetes.io/enforce: restricted
    pod-security.kubernetes.io/enforce-version: latest
TXT

cat <<TXT | k apply -f -
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: secure-pod
  name: secure-pod
  namespace: security
spec:
  securityContext:
    runAsUser: 1000
    runAsNonRoot: true
    seccompProfile:
      type: RuntimeDefault
  containers:
  - image: nginx
    name: secure-pod
    securityContext:
      allowPrivilegeEscalation: false
      runAsUser: 1000
      capabilities:
        drop: ["ALL"]
    volumeMounts:
    - name: html
      mountPath: /usr/share/nginx/html
  dnsPolicy: ClusterFirst
  restartPolicy: Always
  volumes:
  - name: html
    emptyDir: {}
TXT
```
**Review**

* [Seccomp and Kubernetes]
* [Create a Pod that uses the container runtime default seccomp profile]
* [Enforce Pod Security Standards with Namespace Labels]
* [Security context]
* [Restrict a Container's Syscalls with seccomp]

## Q7 Answer

```shell
k taint node k3d-cluster-agent-1 special-workload=true:NoSchedule

k --dry-run=client -o yaml create deployment -n scheduling --replicas=2 --image=nginx toleration-deploy

cat <<TXT | k apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: toleration-deploy
  name: toleration-deploy
  namespace: scheduling
spec:
  replicas: 2
  selector:
    matchLabels:
      app: toleration-deploy
  template:
    metadata:
      labels:
        app: toleration-deploy
    spec:
      containers:
      - image: nginx
        name: nginx
      tolerations:
      - key: "special-workload"
        operator: "Equal"
        value: "true"
        effect: "NoSchedule"
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: kubernetes.io/hostname
                operator: In
                values:
                - k3d-cluster-agent-1
TXT

k create deploy -n scheduling --image=nginx --replicas=2 normal-deploy
```

**Review**

* [kubectl taint]

## Q8 Answer

```shell
cat <<TXT | k apply -f -
apiVersion: v1
kind: Service
metadata:
  name: web-svc
  labels:
    app: web-svc
  namespace: stateful
spec:
  ports:
  - port: 80
    name: web
  clusterIP: None
  selector:
    app: web
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web
  namespace: stateful
  labels:
    app: web
spec:
  serviceName: web-svc
  replicas: 3
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      terminationGracePeriodSeconds: 5
      containers:
      - name: app-web
        image: nginx
        ports:
        - containerPort: 80
          name: web
        volumeMounts:
        - name: www
          mountPath: /usr/share/nginx/html
  volumeClaimTemplates:
  - metadata:
      name: www
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: "cold"
      resources:
        requests:
          storage: 1Gi
TXT

k run -n stateful -it --rm --image=nginx svc-tester -- sh
# test with:
curl http://web-svc.stateful.svc.cluster.local
```

**Review**

* [Components]
* [Headless Services]

## Q9 Answer

```shell
k --dry-run=client -o yaml create deployment -n dns-debug --replicas=3 --image=nginx web-app
k --dry-run=client -o yaml expose --cluster-ip='' --port=80 --name=web-svc deployment web-app
k -n dns-debug expose --cluster-ip='' --name=web-svc --port=80 deployment web-app
cat <<TXT | k apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: web-app
  name: web-app
  namespace: dns-debug
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
      - image: nginx
        name: nginx
---
apiVersion: v1
kind: Service
metadata:
  name: web-svc
  namespace: dns-debug
spec:
  ports:
  - name: "80"
    port: 80
    protocol: TCP
  selector:
    app: web-app
---
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: dns-test
  name: dns-test
  namespace: dns-debug
spec:
  containers:
  - image: busybox
    name: dns-test
    command:
    - sh
    - -c
    - "wget -qO- http://web-svc && wget -qO- http://web-svc.dns-debug.svc.cluster.local && sleep 36000"
  dnsPolicy: ClusterFirst
  restartPolicy: Always
  dnsConfig:
    searches:
    - dns-debug.svc.cluster.local
    - svc.cluster.local
    - cluster.local
TXT

k --dry-run=client -o yaml -n dns-debug run --image=busybox dns-test --command -- sh -c "wget -qO- http://web-svc && wget -qO- http://web-svc.dns-debug.svc.cluster.local && sleep 36000"
k --dry-run=client -o yaml create cm -n dns-debug dns-config
cat <<TXT | k apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: dns-config
  namespace: dns-debug
data:
  search-domains: |
    search dns-debug.svc.cluster.local svc.cluster.local cluster.local
TXT

k get deployment,svc,po,cm -n dns-debug
```

**Review**

## Q10 Answer

lookup how to: The test results should include both the service DNS resolution and FQDN resolution.

```shell
k -n dns-config create deployment --replicas=2 --image=nginx dns-app

cat <<TXT | k apply -f -
apiVersion: v1
kind: Service
metadata:
  name: dns-svc
  namespace: dns-config
spec:
  selector:
    app: dns-app
  ports:
    - protocol: TCP
      port: 80
TXT

k --dry-run=client -o yaml -n dns-config run --image=infoblox/dnstools --command dns-tester -- sh -c "nslookup dns-svc > /tmp/dns-test.txt && nslookup dns-svc.dns-config.svc.cluster.local >> /tmp/dns-test.txt && sleep 1d"
cat <<TXT | k apply -f -
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: dns-tester
  name: dns-tester
  namespace: dns-config
spec:
  containers:
  - image: infoblox/dnstools
    name: dns-tester
    command:
    - sh
    - -c
    - |
      nslookup dns-svc > /tmp/dns-test.txt
      nslookup dns-svc.dns-config.svc.cluster.local >> /tmp/dns-test.txt
      sleep 1d
  dnsPolicy: ClusterFirst
  restartPolicy: Always
TXT

k exec -it -n dns-config dns-tester -- cat /tmp/dns-test.txt | tee /tmp/dns-test.txt
```

**Review**

* [Debugging DNS Resolution]

## Q11 Answer

```shell
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update bitnami
helm install web-release bitnami/nginx -n helm-test --set=service.type=NodePort,replicaCount=2
```

**Review**

* [NGINX Open Source packaged by Bitnami]

## Q12 Answer (Flag)

```shell
k --dry-run=client -o yaml create deployment --image=nginx --replicas=2 nginx | tee /tmp/exam/kustomize/base/deployment.yaml

cat <<TXT | tee /tmp/exam/kustomize/base/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - image: nginx
        name: nginx
        volumeMounts:
        - mountPath: /usr/share/nginx/html
          name: nginx-index
      volumes:
      - name: nginx-index
        configMap:
          name: nginx-config
TXT
cat <<TXT | tee /tmp/exam/kustomize/base/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
- deployment.yaml
TXT

cat <<TXT | tee /tmp/exam/kustomize/overlays/production/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: kustomize
resources:
- ../../base
configMapGenerator:
- name: nginx-config
  literals:
  - index.html=Welcome to Production
labels:
- pairs:
    environment: production
  includeSelectors: true
patches:
- path: deployment.yaml
TXT

cat <<TXT | tee /tmp/exam/kustomize/overlays/production/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 3
TXT

# review the kustomization
k kustomize /tmp/exam/kustomize/overlays/production
k apply -k /tmp/exam/kustomize/overlays/production
```

**Review**

* [Bases and Overlays]
* [Kustomize Built-Ins]

## Q13 Answer

```shell
k create deployment --image=nginx -n gateway app1
k create deployment --image=nginx -n gateway app2

cat <<TXT | k apply -f -
apiVersion: gateway.networking.k8s.io/v1beta1
kind: Gateway
metadata:
  name: main-gateway
  namespace: gateway
spec:
  gatewayClassName: standard
  listeners:
  - name: http
    protocol: HTTP
    port: 80
    allowedRoutes:
      namespaces:
        from: Same
TXT

cat <<TXT | k apply -f -
apiVersion: gateway.networking.k8s.io/v1beta1
kind: HTTPRoute
metadata:
  name: main-gateway-httproute
  namespace: gateway
spec:
  parentRefs:
  - name: main-gateway
  hostnames:
  - "app1-svc"
  - "app2-svc"
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /app1
    backendRefs:
    - name: app1-svc
      port: 8080
  - matches:
    - path:
        type: PathPrefix
        value: /app2
    backendRefs:
    - name: app2-svc
      port: 8080
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: app1
  name: app1
  namespace: gateway
spec:
  replicas: 1
  selector:
    matchLabels:
      app: app1
  template:
    metadata:
      labels:
        app: app1
    spec:
      containers:
      - image: nginx
        name: nginx
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: app2
  name: app2
  namespace: gateway
spec:
  replicas: 1
  selector:
    matchLabels:
      app: app2
  template:
    metadata:
      labels:
        app: app2
    spec:
      containers:
      - image: nginx
        name: nginx
---
apiVersion: v1
kind: Service
metadata:
  name: app1-svc
  labels:
    app: app1-svc
  namespace: gateway
spec:
  ports:
  - port: 8080
    targetPort: 80
  selector:
    app: app1
---
apiVersion: v1
kind: Service
metadata:
  name: app2-svc
  labels:
    app: app2-svc
  namespace: gateway
spec:
  ports:
  - port: 8080
    targetPort: 80
  selector:
    app: app2
TXT

k run -it --rm -n gateway --image=infoblox/dnstools dns-tester
```

**Review**

## Q14 Answer

```shell
cat <<TXT | k apply -f -
apiVersion: v1
kind: LimitRange
metadata:
  name: cpu-resource-constraint
  namespace: limits
spec:
  limits:
  - default:
      cpu: 200m
      memory: 256Mi
    defaultRequest:
      cpu: 100m
      memory: 128Mi
    max:
      cpu: 500m
      memory: 512Mi
    type: Container
---
apiVersion: v1
kind: ResourceQuota
metadata:
  name: pods-medium
  namespace: limits
spec:
  hard:
    cpu: 2
    memory: 2Gi
    pods: 5
TXT
k create deployment --image=nginx --replicas=2 -n limits test-limits
```

**Review**

* [Viewing and Setting Quotas]

## Q15 Answer

```shell
k create deployment -n monitoring --replicas=3 \
  --image=gcr.io/kubernetes-e2e-test-images/resource-consumer:1.5 resource-consumer --dry-run=client -o yaml

cat <<TXT | k apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: resource-consumer
  name: resource-consumer
  namespace: monitoring
spec:
  replicas: 3
  selector:
    matchLabels:
      app: resource-consumer
  strategy: {}
  template:
    metadata:
      labels:
        app: resource-consumer
    spec:
      containers:
      - image: gcr.io/kubernetes-e2e-test-images/resource-consumer:1.5
        name: resource-consumer
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 200m
            memory: 256Mi
TXT

k --dry-run=client -o yaml -n monitoring autoscale --min=3 --max=6 --cpu=50% deployment resource-consumer
cat <<TXT | k apply -f -
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: resource-consumer
  namespace: monitoring
spec:
  maxReplicas: 6
  metrics:
  - resource:
      name: cpu
      target:
        averageUtilization: 50
        type: Utilization
    type: Resource
  minReplicas: 3
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: resource-consumer
TXT
```

**Review**

## Q16 Answer

```shell
k -n cluster-admin create serviceaccount app-admin
k --dry-run=client -o yaml -n cluster-admin create role --verb=list,get,watch --resource=pods app-admin

cat <<TXT | k apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: app-admin
  namespace: cluster-admin
rules:
- apiGroups:
  - ""
  resources: [ "pods"]
  verbs: ["get", "list", "watch"]
- apiGroups:
  - ""
  resources:
  - configmaps
  verbs:
  - create
  - delete
- apiGroups:
  - "apps"
  resources: ["deployments"]
  verbs: ["get", "list", "watch","update"]
TXT
k create rolebinding -n cluster-admin --serviceaccount=cluster-admin:app-admin --role=app-admin app-admin

k --dry-run=client -o yaml -n cluster-admin run --image=bitnami/kubectl:latest admin-pod -- sleep 3600
cat <<TXT | k apply -f -
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: admin-pod
  name: admin-pod
  namespace: cluster-admin
spec:
  containers:
  - command:
    - sleep
    - "3600"
    image: bitnami/kubectl:latest
    name: admin-pod
  serviceAccountName: app-admin
  dnsPolicy: ClusterFirst
  restartPolicy: Always
TXT

k -n cluster-admin exec -it admin-pod -- bash
# kubectl get pods,deployment
```

**Review**

## Q17 Answer (Flag)

```shell
k create deployment -n network --image=nginx --dry-run=client -oyaml web
cat <<TXT | k apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
  namespace: network
spec:
  replicas: 1
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - image: nginx
        name: nginx
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: api
  name: api
  namespace: network
spec:
  replicas: 1
  selector:
    matchLabels:
      app: api
  template:
    metadata:
      labels:
        app: api
    spec:
      containers:
      - image: nginx
        name: nginx
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: db
  name: db
  namespace: network
spec:
  replicas: 1
  selector:
    matchLabels:
      app: db
  template:
    metadata:
      labels:
        app: db
    spec:
      containers:
      - image: postgres
        name: postgres
        env:
        - name: POSTGRES_HOST_AUTH_METHOD
          value: "trust"
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: app-web
  namespace: network
spec:
  podSelector:
    matchLabels:
      app: web
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: api
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: app-api
  namespace: network
spec:
  podSelector:
    matchLabels:
      app: api
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: web
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: db
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: app-db
  namespace: network
spec:
  podSelector:
    matchLabels:
      app: db
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: api
TXT

k exec -it -n network
# wget --spider --timeout=1 nginx
# curl http://<pod-ip>/
```

## Q18 Answer

```shell
k --dry-run=client -o yaml -n upgrade create deployment --replicas=4 --image=nginx:1.19 app-v1
cat <<TXT | k apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: app-v1
  name: app-v1
  namespace: upgrade
spec:
  replicas: 4
  selector:
    matchLabels:
      app: app-v1
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
  template:
    metadata:
      labels:
        app: app-v1
    spec:
      containers:
      - image: nginx:1.19
        name: nginx
TXT

kubectl -n upgrade set image deployment/app-v1 nginx=nginx:1.20 --record

kubectl rollout history deployment app-v1 -n upgrade | tee /tmp/exam/rollout-history.txt

k -n upgrade rollout undo deployment/app-v1
```

**Review**

* [Strategy]

## Q19 Answer

```shell
cat <<TXT | k apply -f -
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: high-priority
  namespace: scheduling
value: 1000
globalDefault: false
description: "High priority class."
---
apiVersion: scheduling.k8s.io/v1
kind: PriorityClass
metadata:
  name: low-priority
  namespace: scheduling
value: 100
globalDefault: false
description: "Low priority class."
---
apiVersion: v1
kind: Pod
metadata:
  name: high-priority
  namespace: scheduling
  labels:
    app: high-priority
spec:
  containers:
  - name: high-priority
    image: nginx
  priorityClassName: high-priority
  affinity:
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
          - key: app
            operator: In
            values:
            - low-priority
        topologyKey: "kubernetes.io/hostname"
---
apiVersion: v1
kind: Pod
metadata:
  name: low-priority
  namespace: scheduling
  labels:
    app: low-priority
spec:
  affinity:
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
          - key: app
            operator: In
            values:
            - high-priority
        topologyKey: "kubernetes.io/hostname"
  containers:
  - name: nginx
    image: nginx
  priorityClassName: low-priority
TXT

k --dry-run=client -o yaml -n monitoring run --image=polinux/stress --command stresser -- stress -c 4 -m 2 --vm-bytes 1G
cat <<TXT | k apply -f -
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: stresser
  name: stresser
  namespace: monitoring
spec:
  containers:
  - command:
    - stress
    - -c
    - "4"
    - -m
    - "2"
    - --vm-bytes
    - 1G
    image: polinux/stress
    name: stresser
  dnsPolicy: ClusterFirst
  restartPolicy: Always
TXT
```
**Review**

* [Example PriorityClass]
* [PriorityClass]

## Q20

```shell
k -n troubleshoot edit deployment failing-app
# updated the container port to 80 then the liveness probe also to 80
# changed memory limit to 256Mi
# saved and exited, the 3 pods were running successfully.
```
---

[Using Dynamic Provisioning]: https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/#using-dynamic-provisioning
[Claims As Volumes]: https://kubernetes.io/docs/concepts/storage/persistent-volumes/#claims-as-volumes
[StorageClass objects]: https://kubernetes.io/docs/concepts/storage/storage-classes/#storageclass-objects
[Create a PersistentVolume]: https://kubernetes.io/docs/tutorials/configuration/configure-persistent-volume-storage/#create-a-persistentvolume
[Node Affinity]: https://kubernetes.io/docs/concepts/storage/persistent-volumes/#node-affinity
[Enforce Pod Security Standards with Namespace Labels]: https://kubernetes.io/docs/tasks/configure-pod-container/enforce-standards-namespace-labels/
[Security context]: https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#security-context
[Seccomp and Kubernetes]: https://kubernetes.io/docs/reference/node/seccomp/
[kubectl taint]: https://kubernetes.io/docs/reference/kubectl/generated/kubectl_taint/
[Components]: https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/
[Restrict a Container's Syscalls with seccomp]: https://kubernetes.io/docs/tutorials/security/seccomp/
[Add a label to a node]: https://kubernetes.io/docs/tasks/configure-pod-container/assign-pods-nodes/#add-a-label-to-a-node
[Create a Pod that uses the container runtime default seccomp profile]: https://kubernetes.io/docs/tutorials/security/seccomp/#create-a-pod-that-uses-the-container-runtime-default-seccomp-profile
[Headless Services]: https://kubernetes.io/docs/concepts/services-networking/service/#headless-services
[Debugging DNS Resolution]: https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/
[Bases and Overlays]: https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/#bases-and-overlays
[Operators]: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#operators
[Viewing and Setting Quotas]: https://kubernetes.io/docs/concepts/policy/resource-quotas/#viewing-and-setting-quotas
[Example PriorityClass]: https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/#example-priorityclass
[PriorityClass]: https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/#priorityclass
[NGINX Open Source packaged by Bitnami]: https://artifacthub.io/packages/helm/bitnami-aks/nginx
[Kustomize Built-Ins]: https://kubectl.docs.kubernetes.io/references/kustomize/builtins/
[Strategy]: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy
