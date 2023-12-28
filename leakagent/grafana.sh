#!/bin/bash
set -e
here=$(realpath $(dirname "$0"))
cd "$here"

echo "Go to http://localhost:8080 for Grafana access. Username is admin, password is admin."

kubectl -n monitoring port-forward svc/prometheus-grafana 8080:80