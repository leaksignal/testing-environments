#!/bin/bash
set -e

#uncomment when continuously restarting for testing
kind delete cluster --name webgoat-cluster &&\

#comment docker builds out after first build unless actively changing/developing
docker build -t example/pythonserver servers/python/ &&\
docker build -t example/node-test-server servers/node/ &&\

kind create cluster --config=kubernetes/cluster.yaml &&\
kind load docker-image example/pythonserver --name webgoat-cluster &&\
kind load docker-image example/node-test-server --name webgoat-cluster &&\
kubectl create configmap proxy-config --from-file kubernetes/envoy.yaml &&\
docker exec -it webgoat-cluster-control-plane crictl images &&\
kubectl apply -f kubernetes/python-deployment.yaml &&\
kubectl apply -f kubernetes/node-test-server-deployment.yaml &&\
kubectl apply -f kubernetes/webgoat-deployment.yaml &&\
kubectl apply -f kubernetes/envoy-deployment.yaml &&\
kubectl apply -f kubernetes/echo-deployment.yaml &&\

### Start prometheus & grafana

kubectl create namespace monitoring &&\
kubectl create -f kubernetes/monitoring/clusterRole.yaml &&\
kubectl create -f kubernetes/monitoring/config-map.yaml &&\
kubectl create  -f kubernetes/monitoring/prometheus-deployment.yaml &&\
kubectl get deployments --namespace=monitoring &&\
kubectl create -f kubernetes/monitoring/prometheus-service.yaml --namespace=monitoring &&\

kubectl create -f kubernetes/monitoring/grafana-datasource-config.yaml &&\
kubectl create -f kubernetes/monitoring/deployment.yaml &&\
kubectl create -f kubernetes/monitoring/service.yaml
