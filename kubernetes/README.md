# Learning: Kubernetes

This Kubernetes booklet starts from leaning what a cluster is; To setting up
one for practice. Then moving into various practice exercises until you are
confident you can manage one or more professionally in a real production
environment.

Begin at the [Preface] and follow the "Next" links at the bottom of each page.

## Table of Contents

* [Preface]
* [Control Plane]
  * [kubelet]
  * [etcd]
  * [kube-apiserver]
  * [kube-controller-manager]
  * [kube-scheduler]
  * [kube-proxy]
* [Cluster Installation Overview]
* [Local Virtual Environment]
  * [Setup A Virtual Environment]
  * [Configure SSH From A JumpBox]
  * [Install containerd]
  * [Install Kubernetes Packages]
* [Manual Cluster Install]
  * [Generate Control Plane Certificates Manually]
  * [Generate Control Plane kubeconfigs Manually]
  * [Generate Static Pod Manifests]
  * [Initialize the Control Plane]
  * [TLS bootstrapping]
  * [Configure Networking]
  * [Add Workers]
* [kubeadm Cluster Install]
  * [Configure Networking]
  * [Join Workers]
  * [Gateway API]
* [Cluster Install on AWS]
  * [Prepare Cloud Machines for Cluster Install]
  * [Install Kubernetes Packages]
  * [Build A kubeadm Init Config]
  * [kubeadm Cluster Install on AWS]
  * [Install AWS Load Balancer Controller]
  * [Join Worker Nodes]
  * [Install cert-manager]
  * [Deploy an AWS Load Balanced Service]
  * [AWS VPC CNI Preface]
* [Post Installation]
  * [Cluster Backups]
  * [Add Metrics Server]
* [Guides]
  * [Generate an API Token]
  * [Guides: Configuring Pod Containers]
  * [Guides: Add A User]
  * [Configure Kube-Router for Networking]
  * [Guides: Cluster Maintenance]
  * [Networking]
  * [Security]
  * [Rejoin Node]
* [Exercises]
  * [Exercises: Add A User]
  * [Exercises: Make A Deployment]
  * [Pod Termination]
* [CKA Exam Prep]
  * [Storage]
  * [Workloads and Scheduling]
  * [Servicing and Networking]
  * [Troubleshooting]
  * [Cluster Architecture, Installation and Configuration]
* [Explanations]
  * [Container Runtime Interface]
  * [Role Based Access Control]
  * [Pod Scheduling]
  * [Connectivity Between Pods]
  * [Connecting Applications with Services]
  * [Job with Pod-to-Pod Communication]
  * [Volumes]
  * [Define and enforce Network Policies]
  * [Use ClusterIP, NodePort, LoadBalancer Service Types and Endpoints]
  * [Logging and Monitoring]
  * [Kubernetes Components Certificates]
  * [Directories]
* [Reference]
  * [Pod]
  * [Static Pod]
  * [Deployment]
  * [Daemon Sets]
  * [StatefulSets]
  * [Storage Class]
  * [Persistent Volume]
  * [Persistent Volume Claim]
  * [ConfigMap]
  * [Secrets]
  * [Network Policies]
  * [Service]
  * [Endpoint Slice]
  * [Labels & Selectors]
  * [Taints and Tolerances]
  * [Ingress]
  * [Admission Controllers]
  * [Pod Security Admission]
  * [Troubleshoot]
  * [Useful Commands]
  * [Resources]

---

[Preface]: /kubernetes/000.0-preface.md
[Control Plane]: /kubernetes/001.0-control-plane.md
[kubelet]: /kubernetes/001.1-kubelet.md
[etcd]: /kubernetes/001.2-etcd.md
[kube-apiserver]: /kubernetes/001.3-kube-apiserver.md
[kube-controller-manager]: /kubernetes/001.4-kube-controller-manager.md
[kube-scheduler]: /kubernetes/001.5-kube-scheduler.md
[kube-proxy]: /kubernetes/001.6-kube-proxy.md
[Cluster Installation Overview]: /kubernetes/002.0-cluster-installation-overview.md
[Local Virtual Environment]: /kubernetes/003.0-local-virtual-environment.md
[Setup A Virtual Environment]: /kubernetes/003.1-setup-a-virtual-environment.md
[Configure SSH From A JumpBox]: /kubernetes/003.2-configure-ssh-from-a-jump-box.md
[Install containerd]: /kubernetes/003.3-install-containerd.md
[Install Kubernetes Packages]: /kubernetes/003.4-install-kubernetes-packages.md
[Manual Cluster Install]: /kubernetes/004.0-manual-cluster-install.md
[Generate Control Plane Certificates Manually]: /kubernetes/004.1-generate-control-plane-certificates-manually.md
[Generate Control Plane kubeconfigs Manually]: /kubernetes/004.2-generate-control-plane-kubeconfigs-manually.md
[Generate Static Pod Manifests]: /kubernetes/004.3-generate-static-pod-manifests.md
[Initialize the Control Plane]: /kubernetes/004.4-initialize-the-control-plane.md
[TLS bootstrapping]: /kubernetes/004.5-tls-bootstrapping.md
[Configure Networking]: /kubernetes/004.6-configure-networking.md
[Add Workers]: /kubernetes/004.7-add-workers.md
[kubeadm Cluster Install]: /kubernetes/005.0-kubeadm-cluster-install.md
[Configure Networking]: /kubernetes/007.1-configure-networking.md
[Join Workers]: /kubernetes/005.2-join-workers.md
[Gateway API]: /kubernetes/005.3-install-gateway-api.md
[Cluster Install on AWS]: /kubernetes/006.0-cluster-install-on-aws.md
[Prepare Cloud Machines for Cluster Install]: /kubernetes/006.1-prepare-cloud-machines-for-cluster-install.md
[Install Kubernetes Packages]: /kubernetes/006.2-install-kubernetes-packages.md
[Build A kubeadm Init Config]: /kubernetes/006.3-build-kubeadm-init-config.md
[kubeadm Cluster Install on AWS]: /kubernetes/006.4-kubeadm-cluster-install-aws.md
[Install AWS Load Balancer Controller]: /kubernetes/006.5-install-aws-load-balancer-controller.md
[Join Worker Nodes]: /kubernetes/006.6-join-worker-nodes.md
[Install cert-manager]: /kubernetes/006.7-install-cert-manager.md
[Deploy an AWS Load Balanced Service]: /kubernetes/006.8-deploy-aws-load-balanced-service.md
[AWS VPC CNI Preface]: /kubernetes/006.9-aws-vpc-cni-preface.md
[Post Installation]: /kubernetes/007.0-cluster-administration.md
[Cluster Backups]: /kubernetes/007.2-cluster-backups.md
[Add Metrics Server]: /kubernetes/007.4-add-metrics-server.md
[Guides]: /kubernetes/008.0-guides.md
[Generate an API Token]: /kubernetes/008.1-generate-an-api-token.md
[Guides: Configuring Pod Containers]: /kubernetes/008.2-configuring-pod-containers.md
[Guides: Add A User]: /kubernetes/008.4-add-a-user.md
[Configure Kube-Router for Networking]: /kubernetes/008.5-configure-kube-router-for-networking.md
[Guides: Cluster Maintenance]: /kubernetes/008.6-cluster-maintenance.md
[Networking]: /kubernetes/008.7-networking.md
[Security]: /kubernetes/008.8-security.md
[Rejoin Node]: /kubernetes/008.9-rejoin-a-node.md
[Exercises]: /kubernetes/009.0-exercises.md
[Exercises: Add A User]: /kubernetes/009.1-add-a-user.md
[Exercises: Make A Deployment]: /kubernetes/009.2-make-a-deployment.md
[Pod Termination]: /kubernetes/009.3-pod-termination.md
[CKA Exam Prep]: /kubernetes/010.0-cka-exam-prep.md
[Storage]: /kubernetes/010.1-storage.md
[Workloads and Scheduling]: /kubernetes/010.2-workloads-and-scheduling.md
[Servicing and Networking]: /kubernetes/010.3-servicing-and-networking.md
[Troubleshooting]: /kubernetes/010.4-troubleshooting.md
[Cluster Architecture, Installation and Configuration]: /kubernetes/010.5-cluster-architecture-installation-and-configuration.md
[Explanations]: /kubernetes/011.0-explanations.md
[Container Runtime Interface]: /kubernetes/011.1-cri.md
[Role Based Access Control]: /kubernetes/011.2-role-based-access-control.md
[Pod Scheduling]: /kubernetes/011.3-pod-scheduling.md
[Connectivity Between Pods]: /kubernetes/011.4-connectivity-between-pods.md
[Connecting Applications with Services]: /kubernetes/011.5-connecting-applications-with-services.md
[Job with Pod-to-Pod Communication]: /kubernetes/011.6-job-with-pod-to-pod-communication.md
[Volumes]: /kubernetes/011.7-volumes.md
[Define and enforce Network Policies]: /kubernetes/011.8-define-and-enforce-network-policies.md
[Use ClusterIP, NodePort, LoadBalancer Service Types and Endpoints]: /kubernetes/011.9-use-clusterip-nodeport-loadbalancer-service-types-and-endpoints.md
[Logging and Monitoring]: /kubernetes/011.10-logging-and-monitoring.md
[Kubernetes Components Certificates]: /kubernetes/011.11-kubernetes-components-certificates.md
[Directories]: /kubernetes/011.12-directories.md
[Reference]: /kubernetes/012.0-reference.md
[Pod]: /kubernetes/012.1-pod.md
[Static Pod]: /kubernetes/012.2-static-pod.md
[Deployment]: /kubernetes/012.3-deployment.md
[Daemon Sets]: /kubernetes/012.4-daemonset.md
[StatefulSets]: /kubernetes/012.5-statefulsets.md
[Storage Class]: /kubernetes/012.6-storage-class.md
[Persistent Volume]: /kubernetes/012.7-persistent-volume.md
[Persistent Volume Claim]: /kubernetes/012.8-persistent-volume-claim.md
[ConfigMap]: /kubernetes/012.9-config-map.md
[Secrets]: /kubernetes/012.10-secrets.md
[Network Policies]: /kubernetes/012.11-network-policies.md
[Service]: /kubernetes/012.12-service.md
[Endpoint Slice]: /kubernetes/012.13-endpoint-slice.md
[Labels & Selectors]: /kubernetes/012.14-labels-and-selectors.md
[Taints and Tolerances]: /kubernetes/012.15-taints-and-tolerances.md
[Ingress]: /kubernetes/012.16-ingress.md
[Admission Controllers]: /kubernetes/012.17-admission-controllers.md
[Pod Security Admission]: /kubernetes/012.18-pod-security-admission.md
[Troubleshoot]: /kubernetes/012.19-troubleshoot.md
[Useful Commands]: /kubernetes/013.2-useful-commands.md
[Resources]: /kubernetes/013.0-resources.md
