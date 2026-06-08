#!/bin/sh

set -e
if [  "${CLEANUP}" = "1" ]; then
    kubectl delete clusterrolebinding secret-reader
    kubectl delete clusterrole secret-reader
    kubectl -n project-swan delete serviceaccount secret-reader
    kubectl delete ns project-swan
else
    kubectl create ns project-swan
    kubectl -n project-swan create serviceaccount secret-reader
    kubectl create clusterrole --verb=list --resource=secret secret-reader
    kubectl create clusterrolebinding --clusterrole=secret-reader --serviceaccount=project-swan:secret-reader secret-reader
fi
