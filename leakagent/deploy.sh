#!/bin/bash
set -e
here=$(realpath $(dirname "$0"))
cd "$here"

istioctl install

helm upgrade --install prometheus kube-prometheus-stack \
  --values ./prometheus.yaml \
  --repo https://prometheus-community.github.io/helm-charts \
  --namespace monitoring --create-namespace

helm upgrade --install leakagent oci://registry-1.docker.io/leaksignal/leakagent \
  --version 0.10.1-helm \
  -f ./leakagent.yaml \
  --namespace leakagent --create-namespace

helm upgrade --install leaksignal-operator oci://registry-1.docker.io/leaksignal/leaksignal-operator \
  --version 1.6.2-helm \
  --namespace kube-system

kubectl apply -f ./ns.yaml

kubectl apply -n leakagent-demo -f ./boutique

kubectl apply -n leakagent-demo -f ./leaksignal.yaml

kubectl apply -f ./monitor.yaml

kubectl apply -k ./dashboards