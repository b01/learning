## CKA Simulator A Questions

## Q1
You're asked to extract the following information out of kubeconfig file `/opt/course/1/kubeconfig `on cka9412:

1. Write all kubeconfig context names into `/opt/course/1/contexts`, one per line
2. Write the name of the current context into `/opt/course/1/current-context`
3. Write the client-certificate of user account-0027 base64-decoded into `/opt/course/1/cert`


## Q2

Install the MinIO Operator using Helm in Namespace `minio`. Then configure and
create the Tenant CRD:

1. Create Namespace `minio`
2. Install Helm chart `minio/operator` into the new Namespace. The Helm Release
   should be called `minio-operator`
   ```shell
   helm install minio/operator --create-namespace minio
   ```
3. Update the Tenant resource in `/opt/course/2/minio-tenant.yaml` to include `enableSFTP: true` under features
4. Create the Tenant resource from `/opt/course/2/minio-tenant.yaml`

NOTE: It is not required for MinIO to run properly. Installing the Helm Chart
and the Tenant resource as requested is enough

## Q3

There are two Pods named o3db-* in Namespace project-h800. The Project H800
management asked you to scale these down to one replica to save resources.

try:
```shell
kubectl scale statefulset -n project-h800 o3db --replicas=1
```

## Q4

Check all available Pods in the Namespace project-c13 and find the names of
those that would probably be terminated first if the nodes run out of resources
(cpu or memory).

Write the Pod names into /opt/course/4/pods-terminated-first.txt
Install the metrics server, then user `k top pod -n project-c13`

# Q5

Previously the application api-gateway used some external autoscaler which
should now be replaced with a HorizontalPodAutoscaler (HPA). The application
has been deployed to Namespaces api-gateway-staging and api-gateway-prod like
this:

kubectl kustomize /opt/course/5/api-gateway/staging | kubectl apply -f -
kubectl kustomize /opt/course/5/api-gateway/prod | kubectl apply -f -
Using the Kustomize config at /opt/course/5/api-gateway do the following:

Remove the ConfigMap horizontal-scaling-config completely
Add HPA named api-gateway for the Deployment api-gateway with min 2 and max 4 replicas. It should scale at 50% average CPU utilisation
In prod the HPA should have max 6 replicas
Apply your changes for staging and prod so they're reflected in the cluster

## Q6

Create a new PersistentVolume named safari-pv. It should have a capacity of 2Gi,
accessMode ReadWriteOnce, hostPath /Volumes/Data and no storageClassName
defined.

Next create a new PersistentVolumeClaim in Namespace `project-t230` named
`safari-pvc` . It should request **2Gi** storage, accessMode **ReadWriteOnce**
and should not define a storageClassName. The PVC should bound to the PV
correctly.

Finally create a new Deployment safari in Namespace `project-t230` which mounts
that volume at `/tmp/safari-data`. The Pods of that Deployment should be of image
`httpd:2-alpine`.


## Q7

The metrics-server has been installed in the cluster. Write two bash scripts
which use kubectl:

Script `/opt/course/7/node.sh` should show resource usage of nodes
Script `/opt/course/7/pod.sh` should show resource usage of Pods and their
containers

## Q8

Your coworker notified you that node cka3962-node1 is running an older
Kubernetes version and is not even part of the cluster yet.

Update the node's Kubernetes to the exact version of the controlplane

Add the node to the cluster using kubeadm

ℹ️ You can connect to the worker node using ssh cka3962-node1 from cka3962


## Q9

There is ServiceAccount secret-reader in Namespace project-swan. Create a Pod of image nginx:1-alpine named api-contact which uses this ServiceAccount.

Exec into the Pod and use curl to manually query all Secrets from the Kubernetes Api.

Write the result into file /opt/course/9/result.json.


## Q10

Create a new ServiceAccount processor in Namespace project-hamster. Create a Role and RoleBinding, both named processor as well. These should allow the new SA to only create Secrets and ConfigMaps in that Namespace.

## Q11

Use Namespace project-tiger for the following. Create a DaemonSet named ds-important with image httpd:2-alpine and labels id=ds-important and uuid=18426a0b-5f59-4e10-923f-c0e078e82462. The Pods it creates should request 10 millicore cpu and 10 mebibyte memory. The Pods of that DaemonSet should run on all nodes, also controlplanes.

## Q12

Implement the following in Namespace project-tiger:

* Create a Deployment named deploy-important with 3 replicas
* The Deployment and its Pods should have label id=very-important
* First container named container1 with image nginx:1-alpine
* Second container named container2 with image google/pause
* There should only ever be one Pod of that Deployment running on one worker
  node, use topologyKey: kubernetes.io/hostname for this

NOTES: Because there are two worker nodes and the Deployment has three replicas
the result should be that the third Pod won't be scheduled. In a way this
scenario simulates the behaviour of a DaemonSet, but using a Deployment with a
fixed number of replicas

## Q13

The team from Project r500 wants to replace their Ingress (networking.k8s.io) with a Gateway Api (gateway.networking.k8s.io) solution. The old Ingress is available at /opt/course/13/ingress.yaml.

Perform the following in Namespace project-r500 and for the already existing Gateway:

1. Create a new HTTPRoute named traffic-director which replicates the routes from the old Ingress
2. Extend the new HTTPRoute with path /auto which forwards to mobile backend if the User-Agent is exactly mobile and to desktop backend otherwise
   The existing Gateway is reachable at http://r500.gateway:30080 which means your implementation should work for these commands:

curl r500.gateway:30080/desktop
curl r500.gateway:30080/mobile
curl r500.gateway:30080/auto -H "User-Agent: mobile"
curl r500.gateway:30080/auto

## Q14

Perform some tasks on cluster certificates:

1. Check how long the kube-apiserver server certificate is valid using openssl or cfssl. Write the expiration date into /opt/course/14/expiration. Run the kubeadm command to list the expiration dates and confirm both methods show the same one
2. Write the kubeadm command that would renew the kube-apiserver certificate into /opt/course/14/kubeadm-renew-certs.sh


## Q15

Solve this question on: ssh cka7968

There was a security incident where an intruder was able to access the whole
cluster from a single hacked backend Pod.

To prevent this create a NetworkPolicy called np-backend in Namespace project-snake. It should allow the backend-* Pods only to:

* Connect to db1-* Pods on port 1111
* Connect to db2-* Pods on port 2222

Use the app Pod labels in your policy.

ℹ️ All Pods in the Namespace run plain Nginx images. This allows simple connectivity tests like: k -n project-snake exec POD_NAME -- curl POD_IP:PORT

ℹ️ For example, connections from backend-* Pods to vault-* Pods on port 3333 should no longer work

## Q16

The CoreDNS configuration in the cluster needs to be updated:

1. Make a backup of the existing configuration Yaml and store it at /opt/course/16/coredns_backup.yaml. You should be able to fast recover from the backup
2. Update the CoreDNS configuration in the cluster so that DNS resolution for SERVICE.NAMESPACE.custom-domain will work exactly like and in addition to SERVICE.NAMESPACE.cluster.local

Test your configuration for example from a Pod with busybox:1 image. These commands should result in an IP address:

nslookup kubernetes.default.svc.cluster.local
nslookup kubernetes.default.svc.custom-domain

## Q17

In Namespace project-tiger create a Pod named `tigers-reunite` of image
`httpd:2-alpine` with labels pod=container and container=pod. Find out on which
node the Pod is scheduled. Ssh into that node and find the containerd container
belonging to that Pod.

Using command `crictl`:

1. Write the ID of the container and the info.runtimeType into
   `/opt/course/17/pod-container.txt`
2. Write the logs of the container into
   `/opt/course/17/pod-container.log`

ℹ️ You can connect to a worker node using `ssh cka2556-node1` or
`ssh cka2556-node2` from cka2556

```shell
# First we create the Pod:
k -n project-tiger run tigers-reunite --image=httpd:2-alpine --labels "pod=container,container=pod"

# Next we find out the node it's scheduled on:
k -n project-tiger get pod -o wide

# Here it's cka2556-node1 so we ssh into that node and and check the container info:
sudo crictl ps | grep tigers-reunite

# Having the container we can crictl inspect it for the runtimeType:
crictl inspect ba62e5d465ff0 | grep runtimeType


```