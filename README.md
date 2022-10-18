## LeakSignal Testing Environments

The following infrastructure is used to test LeakSignal detection and alerting policies. 

### Kubernetes
Configuration files for running a Kubernetes cluster are contained in ./kubernetes. Envoy is setup as the ingress proxy and uses a NodePort configuration. 

This K8s cluster deploys instances of WebGoat, an Echo server and 2 custom servers from the ./server directory (node and python). There are 4 total microservices running within this K8s cluster. Envoy is proxying all requests with the LeakSignal WASM filter preinstalled.

LeakSignal Filter Options:
1. local mode (prometheus -> grafana) Metrics are only exported through Envoy and visualized in Grafana.
2. COMMAND mode (send telemetry to cloud dashboard) Metrics are sent to LeakSignal COMMAND for analysis, visualization and alerting. 

#### Prerequisites
* [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)
* [Kind](https://kind.sigs.k8s.io/docs/user/quick-start/)

Run the setup script to stand up the environment:
```
$> sh setup.sh
```

Example files from each application are:
##### Python
* Served from the python app as a simple web server. Oftentimes, node won't allow specific vulnerabilites to be served in the response and python's HTTP server has no limits in the amount of vulns it can serve.
  * http://[IP]:30167/test/hello

  
##### NodeJS (use these files to trigger rules in the LeakSignal policy)
* The following are the output from system commands or lists of PII data for LeakSignal to match on.
  * http://[IP]:30167/node/ssn001.html 
  * http://[IP]:30167/node/ifconfig.html
  * http://[IP]:30167/node/ls.html
  * http://[IP]:30167/node/privatekey.html
  * http://[IP]:30167/node/root.html

##### Webgoat
* http://[IP]::30167/WebGoat/login
  * Webgoat application used to demonstrate how LeakSignal can detect or block an active attack
##### Echo
The echo server is not mapped to external access. It's used for internal cluster testing as needed.

### Monitoring

This is the configuration for a quick and easy monitoring system with Prometheus and Grafana. It gives you visibility of:
* Sensitive data per minute for /*. This allows teams to baseline the current sensitive data that is served from a given path or microservice.
* Exploits per minute. Is there flawed API logic or configuration files causing data to be leaked? Or worse, are you open to an RCE/Ransomware attack?

![](/assets/LS-dashboard-grafana.png)
* Prometheus is at http://[IP]]:9090/targets
* Grafana is at http://[IP]]:9091/login
  * Login with admin:admin
  * Copy and paste the grafana.json file into the "import via panel json" text box under + -> import in the grafana UI.
  

