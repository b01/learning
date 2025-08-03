# Learning: Kubernetes

This covers Kubernetes overview, installation, and administration.
## Overview

1. [Step 1 Take an Online Course](#step-1-take-an-online-course)
2. [Step 2 Work Through Kubernetes The Hard Way](#step-2-work-through-kubernetes-the-hard-way)
3. [Step 3 Install a Cluster with kubeadm](#step-3-install-a-cluster-with-kubeadm)
4. [Step 4 CKA Exam Curriculum](#step-4-cka-exam-curriculum)
5. [Step 5 Commands To Increase Your Speed](#step-5-commands-to-increase-your-speed)

## Step 1 Take an Online Course

This will serve as a good crash-course into Kubernetes, most of them swear they
will be all you need to pass an exam. Their course alone may not be enough
if you're a beginner.

I took the [Certified Kubernetes Administrator (CKA) Course] by KodeKloud. It
will help you get started with hands-on very quickly. It will give you a good
idea of the inner workings of Kubernetes. However, while online courses are a
good primer, in my opinion, they are not enough to take the exam. You'll need
more repetition and troubleshooting experience in order to take the CKA exam
and pass; and even more to talk confidently in interviews.

This was not my first CKA course, but I like KodeKloud because they provided
good labs with feedback, guiding you down the right path. Which is an
indispensable characteristic of any good technical course online or in-person.
Providing confirmation that you are doing some things right is needed 
when you're new to a subject; and a reassuring boost while learning. Again, it's
a critical part of the learning process.

## Step 2 Work Through Kubernetes The Hard Way

In the CKA exam you may need to know where a given configuration is for any
given component. Working through [Kubernetes The Hard Way by Kelsey Hightower]
can help with that and more. Going through this material should help you learn
where basically everything is. Just be careful not to fall into the
copy-paste trap as we often do with most tutorials. You won't learn anything
that way. So I ran though this tutorial until I understood why and how all the
things were done.

I even made my own fork of [Kubernetes The Hard Way] to track my changes and
tweaks to reinforce that knowledge. This includes a vagrant file to set up
Linux virtual machines to use as infrastructure for a local Kubernetes cluster.

You should know that I worked through this more than once, in fact I did it to
the point where I could set up a cluster the hard way by heart, in less than 1
hour without looking at the guide. That way I would be more comfortable on the
exam or any interviews. Only then did I move over to setting up a cluster using
`kubeadm`.

## Step 3 Install a Cluster with kubeadm

[kubeadm Cluster Install]

`kubeadm` tool automates the PKI, configurations, and running components. You'll
need to perform prerequisites on each machine, initialize the cluster,
install a CNI plugin; then add worker nodes. It takes care of a lot of
heavy lifting; streamlining the process.

This guide walks you through the complete process, in addition, it also points
out the links where this info originated from. As you will be able
to use those same links in your CKA exam.

A notable difference between setting things up manually and using a tool
like `kubeadm` is that configurations are not in the same locations. In fact,
`kubeadm` runs the cluster components in a self-contained way. Meaning the
control plane components run as pods in the cluster that you spin up. Cluster
components have their configurations mounted in their containers using
Kubernetes ConfigMaps. And yet, this is all configurable as with installing
things manually.

## Step 4 CKA Exam Curriculum

[CKA Exam Guide v1.32]

This has the exact layout as the official PDF. It adds links to where you can
learn each subject (bullet points) so that you know hot to perform them in the
exam. You'll learn were every configuration is located and how to modify them as
needed. Giving you just about every thing you need to administer a cluster
proper. After which you should be ready to take the exam, and God Willing, pass.

## Step 5 Commands To Increase Your Speed

[Commands To Know] is a list of items that can help you perform task quickly.
If you're not familiar with them, then they may slow you down at first. But
after some comprehension and practice, they should speed you up.

They are also standard and quite useful for any kind of routine maintenance and
configuration of a Linux box, and especially when troubleshooting a cluster.

---

[Certified Kubernetes Administrator (CKA) Course]: https://github.com/kodekloudhub/certified-kubernetes-administrator-course?tab=readme-ov-file
[Kubernetes The Hard Way by Kelsey Hightower]: https://github.com/kelseyhightower/kubernetes-the-hard-way
[Kubernetes The Hard Way]: https://github.com/b01/kubernetes-the-hard-way
[Commands To Know]: /kubernetes/commands-to-know.md#commands-to-know
[CKA Exam Guide v1.32]: /kubernetes/7.0-cka-exam-curriculum-v1.32.md
[kubeadm Cluster Install]: /kubernetes/5.0-kubeadm-cluster-install.md
