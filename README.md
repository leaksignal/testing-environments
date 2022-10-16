## LeakSignal Testing Environments 

This repository houses testing infrastructure setup for LeakSignal. 

### Kubernetes
Configuration files for running a Kubernetes cluster are contained in ./kubernetes. Envoy is setup as the ingress proxy and uses a NodePort configuration. 

This K8s cluster deploys instances of WebGoat, an Echo server and 2 custom servers from the ./server directory (node and python). So there are 4 total servers running within this K8s cluster with envoy proxying all the requests with the LeakSignal WASM filter preinstalled.

LeakSignal Filter Options:
1. local mode (prometheus -> grafana) Metrics are only exported through Envoy and visualized in Grafana.
2. COMMAND mode (send telemetry to cloud dashboard) Metrics are sent to LeakSignal COMMAND for analysis, visualization and alerting. 

#### Prerequisites
* [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)
* [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/)

Example files from each application are:
##### Python
* http://[IP]:30167/test/hello
  * Served from the python app as a simple web server.
##### NodeJS
* http://[IP]:30167/node/api-response1.json
* http://[IP]:30167/node/ssn001.html
  * serves as a place to put static files for testing
##### Webgoat
* http://[IP]::30167/WebGoat/login
  * Webgoat application used to demonstrate how LeakSignal can detect or block an active attack
##### Echo
The echo server is not mapped to external access. It's used for internal cluster testing as needed.

### Monitoring

This is the configuration for a quick and easy monitoring system with Prometheus and Grafana. 
![](/assets/LS-dashboard-grafana.png | width=50%)
* Prometheus is at http://[IP]]:9090/targets
* Grafana is at http://[IP]]:9091/login
  * Login with admin:admin
  * Copy and paste the grafana.json file into the "import via panel json" text box under + -> import in the grafana UI.
