#!/bin/bash
set -e
here=$(realpath $(dirname "$0"))
cd "$here"

echo "Go to http://localhost:8090 for Boutique frontend access."

kubectl -n istio-system port-forward svc/istio-ingressgateway 8090:80
