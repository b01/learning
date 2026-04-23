# Learning: Kubernetes

This Kubernetes booklet starts from leaning what a cluster is; To setting up
one for practice. Then moving into various practice exercises until you are
confident you can manage one or more professionally in a real production
environment.

Begin at the [Preface] and follow the "Next" links at the bottom of each page.

## Overview

1. [Step 1 Take an Online Course](#step-1-take-an-online-course)
2. [Step 2 Work Through Kubernetes The Hard Way](#step-2-work-through-kubernetes-the-hard-way)
3. [Step 3 Install a Cluster with kubeadm](#step-3-install-a-cluster-with-kubeadm)
4. [Step 4 CKA Exam Curriculum](#step-4-cka-exam-curriculum)
5. [Step 5 Commands To Increase Your Speed](#step-5-commands-to-increase-your-speed)

## Taking an Online Course

This is how I assume most get into Kubernetes. For myself, I was working at a
job and thrown into it.

While a course will serve as a good crash-course into Kubernetes, most of them
swear they will be all you need to pass an exam. I found that their courses
alone were not enough, at least for me, and maybe you too if you're a beginner.

Taking a course is up to you. I don't want to steer you away from this guide,
but it jumps right into using Kubernetes.
While it should be complete enough for a beginner, there is no soft intro.
You're expected to go through the material repeatedly until you understand it
and can run a decent amount of commands without looking them up. There are
also exercises that will give you even more hands-on experience. Allowing you
to learn how to administer Kubernetes so that your confident on your own.

I took the [Certified Kubernetes Administrator (CKA) Course] by KodeKloud. It
will help you get started with hands-on very quickly.; and give you a good
idea of the inner workings of Kubernetes. However, you'll need
more repetition and troubleshooting experience in order to take the CKA exam
and pass; and even more to talk confidently in interviews.

This was not my first CKA course, but I like KodeKloud because they provided
good labs with feedback, guiding you down the right path. Which is an
indispensable characteristic of any good technical course online or in-person.
Providing confirmation that you are doing some things right is needed 
when you're new to a subject; and a reassuring boost while learning. Again, it's
a critical part of the learning process.

## Step 2 Work Through Kubernetes The Hard Way

In the CKA exam you'll need to know where a given configuration for a component
is located on the system, and the purpose of each component so you know exactly
where to begin to troubleshoot a problem quickly.

Walking through deploying a Kubernetes cluster the hard way will help improve
your comprehension and better prepare you for the real thing, exam or work-wise.

This Guide will teach you the type of things you'll need to know that online
courses don't even touch. Going through this material should help you gain the
ability to troubleshoot just about anything with Kubernetes.
Just be careful not to fall into the copy-paste trap as we often do with most
tutorials. You won't learn anything that way. So run though this guide until
you remember without having to look it up. You don't want to be on an emergency
call to find a Kubernetes issue and Googling everything; that just gives someone
else the opportunity to outshine you.

This Guide includes a vagrant file to set up Linux virtual machines using
VirtualBox to use as infrastructure for a local Kubernetes cluster. So you will
get hands-on experience, if your computer can handle the requirements.

You should know that I worked through this more than once. In fact, I did it to
the point where I could set up a cluster the hard way by heart. My best time I
was able to do it in less than 1 hour without looking at this guide. You'll want
to get to that point too. That way you'll be more comfortable on the
exam or the technical part of an interview. Only then did I move over to setting
up a cluster using `kubeadm`. This guide also walks through setting up a
self-hosted non-EKS cluster in AWS, if you are O.K. with spending $5-10 US
dollars for the extra practice. No it doesn't go to me, that is what it may
cost to use the AWS resources.

## Step 3 Install a Cluster with kubeadm

[kubeadm Cluster Install]

`kubeadm` tool automates the PKI, configurations, and running components. You'll
need to perform prerequisites on each machine, initialize the cluster,
install a CNI plugin; then add worker nodes. It takes care of a lot of
heavy lifting; streamlining the process.

This guide walks you through the complete process, in addition, it also points
out the links where this info originated from. As you will be able to use those
same links in your CKA exam.

A notable difference between setting things up manually and using a tool
like `kubeadm` is that configurations for the same components may end up in
different locations. Also, `kubeadm` always runs the cluster components, except
the kubelet, as Pods in the cluster that you spin up. Some clusters out there
can set them up to run on the node itself, which is something I did not understand
before I took the CKA exam. Something those online courses I took did not make
clear. Its important because it determines where you look for a components'
config.

With `kubeadm`, cluster components have their configurations mounted in their
containers using Kubernetes ConfigMaps. So they are stored in the cluster
itself. While the `kubelet`'s config is located on the
host machine, usually in `/var/lib/kubelet/config.yaml`. Pay attention to stuff
like this, it will help you avoid headache during the learning process. If you
are confuse about that, it should become clear by the time you reach the end of
this guide. If not, then post an issue on GitHub for this repo.

## Step 4 CKA Exam Curriculum

[CKA Exam Guide v1.32]

This has the exact layout as the official PDF. It adds links to where you can
learn each subject (bullet points) so that you know hot to perform them in the
exam. You'll learn were every configuration is located and how to modify them as
needed. Giving you just about every thing you need to administer a cluster
proper. After which you should be ready to take the exam, and God Willing, pass.

## Step 5 Commands To Increase Your Speed

[Useful Commands] is a list of items that can help you perform task quickly.
If you're not familiar with them, then they may slow you down at first. But
after some comprehension and practice, they should speed you up.

## Samples

* [Local Storage Class Manifest]

## Background

Online courses I took failed to teach me the finer details of Kubernetes,
something that would trip me up on the exam the first time I took it. So I
began searching how to really understand Kubernetes. That's when I ran into
[Kubernetes The Hard Way by Kelsey Hightower]. Working through it helped me
start to get a better understanding. So I even made my own fork of [Kubernetes
The Hard Way], thinking I could contribute updates there were missing. At the
same time I noticed that there were still some pretty big gaps in my knowledge.
So I made this repository to fill those in.

So I began placing my extra learning into this guide (compedium of my knowledge). However, while developing
this guide, I went deeper than "Kubernetes the Hard Way" did, and I just kept
updating it. Once I started using added the Virtual environment to practice
I started to focus on this repo alone. So here we are.

---

[Certified Kubernetes Administrator (CKA) Course]: https://github.com/kodekloudhub/certified-kubernetes-administrator-course?tab=readme-ov-file
[Kubernetes The Hard Way by Kelsey Hightower]: https://github.com/kelseyhightower/kubernetes-the-hard-way
[Kubernetes The Hard Way]: https://github.com/b01/kubernetes-the-hard-way
[Useful Commands]: /kubernetes/017.5-useful-commands.md
[CKA Exam Guide v1.32]: /kubernetes/007.0-cka-exam-curriculum-v1.32.md
[kubeadm Cluster Install]: /kubernetes/005.0-kubeadm-cluster-install.md
[Preface]: /kubernetes/000.0-preface.md
