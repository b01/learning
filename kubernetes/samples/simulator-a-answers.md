# Answers

## Q1

```shell
kubectl config get-context --kubeconfig /opt/course/1/kubeconfig --no-headers
kubectl config current-context --kubeconfig /opt/course/1/kubeconfig
kubectl config view --kubeconfig /opt/course/1/kubeconfig \
  --raw -o jsonpath='{.users[0].user.client-certificate-data}' \
  | base64 -d | openssl x509 -text -noout | tee /opt/course/1/cert

```

## Q2


```shell
kubectl create namespace minio
helm -n minio install minio-operator minio/operator
vi /opt/course/2/minio-tenant.yaml
```

## Q3

```shell
k scale statefulset -n project-h800 o3db --replicas=1
```

## Q5

```shell
kubectl autoscale deployment -n api-gateway-staging api-gateway --cpu=50% --min=2 --max=4 -o yaml --dry-run \
 tee hpa.yaml
```
```yaml

```

## Q6

```shell
cat <<TXT | tee q6-pv.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: safari-pv
  labels:
    type: local
spec:
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/Volumes/Data"

TXT

cat <<TXT | tee q6-pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: safari-pvc
  namespace: project-t230
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
TXT


cat <<TXT | tee q6-deploy.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: safari
  namespace: project-t230
spec:
  replicas: 1
  selector:
    matchLabels:
      app: httpd
  template:
    metadata:
      labels:
        app: httpd
    spec:
      volumes:
        - name: q6-pv-storage
          persistentVolumeClaim:
            claimName: safari-pvc
      containers:
      - name: web-server
        image: httpd:2-alpine
        ports:
        - containerPort: 80
        volumeMounts:
        - mountPath: "/tmp/safari-data"
          name: q6-pv-storage
TXT


cat <<TXT | tee q17-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: tigers-reunite
  namespace: project-tiger
  labels:
    pod: container
    container: pod
spec:
  containers:
    - name: tigers-reunite-container
      image: httpd:2-alpine
      ports:
        - containerPort: 80
          name: "http-server"
TXT

sudo critctl ps -a | grep tigers-reunit
CONTAINER           IMAGE               CREATED             STATE               NAME                       ATTEMPT             POD ID              POD                                     NAMESPACE
b5a6b103497cc       df42812185067       2 minutes ago       Running             tigers-reunite-container   0                   4ec7718a33463       tigers-reunite                          project-tiger

sudo crictl inspect b5a6b103497cc | grep runtimeType

io.containerd.runc.v2
```

## Q4

```shell
# these pods use 20Mi, so they will likely get cut first.
# I had this wrong, though I would have gotten it write. I knew I was
# missing some details about how the cluster would execute nodes based on
# criteria. These pods did not have resource limits set, which is what I was
# not thinking about. But I knew to research this after I saw the question.
# I could have easily looked this up too during the exam.

cat << TXT | tee /opt/course/4/pods-terminated-first.txt
c13-2x3-api-5847f4f998-cdm27
c13-2x3-api-5847f4f998-wspln
c13-2x3-api-5847f4f998-x4c72
TXT
```

## Q5

```shell
sudo apt-mark unhold kubeadm kubectl kubelet
sudo apt-get update && sudo apt-get install -y kubeadm='1.35.2-*' kubectl='1.35.2-*' kubelet='1.35.2-*'
sudo apt-mark hold kubeadm kubectl kubelet
```


## Q9

```shell
cat <<TXT | tee po.yaml
apiVersion: v1
kind: Pod
metadata:
  name: api-contact
  namespace: project-swan
spec:
  containers:
  - image: nginx:1-alpine
    name: web-server
    volumeMounts:
    - mountPath: /opt/course/9/
      name: question-9
  serviceAccountName: secret-reader
  volumes:
  - name: question-9
    hostPath:
      path: /opt/course/9/
      type: Directory
TXT

export CLUSTER_NAME="kubernetes"
cat /var/run/secrets/kubernetes.io/serviceaccount/toke


# Bind the servier account so it has permissions.
k create rolebinding secret-reader --clusterrole view --serviceaccount project-swan:secret-reader

# dump the token into a variable
TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
APISERVER="https://192.168.100.21:6443"
# Explore the API with TOKEN
curl -X GET $APISERVER/api/v1/secrets --header "Authorization: Bearer $TOKEN" --insecure
```


## Q10

```shell
kubectl create serviceaccount processor -n project-hamster
kubectl create role processor --verb=create --resource=secrets,configmaps -n project-hamster
k create rolebinding processor --role processor --serviceaccount project-hamster:processor -n project-hamster

secrets: create,delete,deletecollection,get,list,patch,update,watch
cm:      create,delete,deletecollection,get,list,patch,update,watch
```
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: processor
  namespace: project-hamster
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: processor
  namespace: project-hamster
rules:
- apiGroups:
  - ""
  resources:
  - secrets
  - configmaps
  verbs:
  - create
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: processor
  namespace: project-hamster
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: processor
subjects:
- kind: ServiceAccount
  name: processor
  namespace: project-hamster
```

## Q11

```shell
cat <<TXT | tee ds.yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: ds-important
  namespace: project-tiger
  labels:
    id: ds-important
    uuid: 18426a0b-5f59-4e10-923f-c0e078e82462
spec:
  selector:
    matchLabels:
      app.kubernetes.io/name: ds-spec
  template:
    metadata:
      labels:
        app.kubernetes.io/name: ds-spec
    spec:
      containers:
      - name: web-server
        image: httpd:2-alpine
        resources:
          requests:
            memory: "10Mi"
            cpu: "10m"
      tolerations:
        - key: "node-role.kubernetes.io/control-plane"
          operator: "Exists"
          effect: "NoSchedule"
TXT
```

## Q12

```shell
cat <<TXT | tee dp-2.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deploy-important
  namespace: project-tiger
  labels:
    id: very-important
spec:
  replicas: 3
  selector:
    matchLabels:
      app: deploy-important
  strategy: {}
  template:
    metadata:
      labels:
        app: deploy-important
    spec:
      containers:
      - image: nginx:1-alpine
        name: container1
      - image: google/pause
        name: container2
      topologySpreadConstraints:
      - maxSkew: 1
        topologyKey: kubernetes.io/hostname
        whenUnsatisfiable: DoNotSchedule
        labelSelector:
          matchLabels:
            app: deploy-important
TXT
```

## Q13

```yaml
# /opt/course/13/ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: traffic-director
spec:
  ingressClassName: nginx
  rules:
    - host: r500.gateway
      http:
        paths:
          - backend:
              service:
                name: web-desktop
                port:
                  number: 80
            path: /desktop
            pathType: Prefix
          - backend:
              service:
                name: web-mobile
                port:
                  number: 80
            path: /mobile
            pathType: Prefix
```

```shell
cat <<TXT | tee hr.yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: traffic-director
  namespace: project-r500
spec:
  parentRefs: # enter the name of the gateway
  - name: main 
  hostnames:
  - "r500.gateway"
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /desktop
    backendRefs:
    - name: web-desktop
      port: 80
  - matches:
    - path: 
        type: PathPrefix
        value: /mobile
    backendRefs:
    - name: web-mobile
      port: 80
  - matches:
    - path: 
        type: PathPrefix
        value: /auto
      headers:
      - name: User-Agent
        value: mobile
    backendRefs:
    - name: web-mobile
      port: 80
  - matches:
    - path: 
        type: PathPrefix
        value: /auto
    backendRefs:
    - name: web-desktop
      port: 80
TXT
```

## Q14

```shell
sudo kubeadm certs check-expiration | grep apiserver
# remember NOT to put `sudo` in front.
echo "kubeadm certs renew all" | tee /opt/course/14/kubeadm-renew-certs.sh
```

## Q15

```shell
cat <<TXT | tee np.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: np-backend
  namespace: project-snake
spec:
  podSelector:
    matchLabels:
      app: backend
  egress:
  - to:
    - podSelector:
        matchLabels:
         app: db1
    ports:
      - protocol: TCP
        port: 1111
        endPort: 1111
  - to:
    - podSelector:
        matchLabels:
         app: db2
    ports:
      - protocol: TCP
        port: 2222
        endPort: 2222
TXT

# test backend to vault connection
k -n project-snake exec backend-0 -- curl 10.32.0.13:80
# test backend to db-1 connectoin
k -n project-snake exec backend-0 -- curl 10.32.0.11 :80
```

## Q16

```shell
k get cm -n kube-system coredns -o yaml > /opt/course/16/coredns_backup.yaml
k edit cm -n kube-system coredns
k rollout restart deploy -n kube-system coredns
k run -it --rm --image busybox:1 busybee -- sh
```

## Q17

```shell
k create pod -n project-tiger tigers-reunite --image httpd:2-alpine --label
```