#!/bin/bash
set -e
here=$(realpath $(dirname "$0"))
cd "$here"

helm uninstall prometheus --namespace monitoring

helm uninstall leakagent --namespace leakagent

helm uninstall leaksignal-operator --namespace kube-system

kubectl delete -f ./ns.yaml

kubectl delete -k ./dashboards