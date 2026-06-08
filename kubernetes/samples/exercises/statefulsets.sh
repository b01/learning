#!/bin/sh

set -e

cat <<TXT | tee project-h800-statefulset.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: project-h800
---
apiVersion: v1
kind: Service
metadata:
  name: nginx
  namespace: project-h800
  labels:
    app: nginx
spec:
  ports:
  - port: 80
    name: web
  clusterIP: None
  selector:
    app: nginx
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: o3db
  namespace: project-h800
spec:
  selector:
    matchLabels:
      app: nginx
  serviceName: "nginx"
  replicas: 3
  minReadySeconds: 5
  template:
    metadata:
      labels:
        app: nginx
    spec:
      terminationGracePeriodSeconds: 10
      containers:
      - name: nginx
        image: registry.k8s.io/nginx-slim:0.24
        ports:
        - containerPort: 80
          name: web
        volumeMounts:
        - name: www
          mountPath: /usr/share/nginx/html
      volumes:
      - name: www
        hostPath:
          path: /usr/share/nginx/html
TXT

if [  "${CLEANUP}" = "1" ]; then
    kubectl delete -f project-h800-statefulset.yaml
else
    kubectl apply -f project-h800-statefulset.yaml
    kubectl -n project-h800 po -o wide
fi

rm -f project-h800-statefulset.yaml
