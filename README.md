## testing-environments

This repository houses all testing infrastructure setup. 

### ./kubernetes
Configuration files for running a Kubernetes cluster. Envoy is setup as the ingress proxy and uses a NodePort configuration. 

The cluster deploys instances of WebGoat, an Echo server and 2 custom servers from the ./server directory (node and python). So there are 4 total servers running within this K8s cluster with envoy proxying all the requests with the LeakSignal wasm filter preinstalled.

#### Prerequisites
* [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)
* [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/)


Example files from each application are:
##### Python
* http://[IP]:30167/test/hello
  * Served from the python app as a simple web server.
##### NodeJS
* http://[IP]:30167/node/wf2.html
* http://[IP]:30167/node/api-response1.json
* http://[IP]:30167/node/ssn001.html
  * Served from a basic nodejs app as a place to put static files for testing
##### Webgoat
* http://[IP]::30167/WebGoat/login
  * Webgoat application used to demonstrate how leaksignal can detect or block an active attack

The echo server is not mapped to external access. It's used for internal cluster testing as needed.

### ./kubernetes/monitoring

This is the configuration for a quick and easy monitoring system with Prometheus and Grafana. I'm currently using it to monitor envoy performance during testing.

* Prometheus is at http://[IP]]:9090/targets
* Grafana is at http://[IP]]:9091/login
  * Login with admin:admin
  * Copy and paste the grafana.json file into the "import via panel json" text box under + -> import in the grafana UI.
