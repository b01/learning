#!/bin/sh

set -e

if [  "${CLEANUP}" = "1" ]; then
    kubectl delete -f /vagrant/dp-log-worker.yaml
else
    kubectl apply -f /vagrant/dp-log-worker.yaml
    kubectl -n log get po -o wide
fi
