### Online Boutique (Demo)
One easy way to get started is by running Google's [Online Boutique demo](https://github.com/GoogleCloudPlatform/microservices-demo). It's made up of 11 microservices and has a built in load generator. It also prepopulates the the checkout form with a fake credit card number to simulate a checkout experience and that will show up immediately in the LeakSignal metrics.

##### Demo Setup & LeakSignal Installation

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://ssh.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/wesleyhales/microservices-demo.git&cloudshell_workspace=.&cloudshell_tutorial=docs/cloudshell-tutorial.md)

1. Create a GKE cluster with at least 4 nodes, machine type `e2-standard-4`. IF you don't know your PROJECT_ID, [see these instructions](https://cloud.google.com/resource-manager/docs/creating-managing-projects#creating_a_project) on finding or creating one.

    ```
    PROJECT_ID="<your-project-id>"
    gcloud services enable container.googleapis.com --project ${PROJECT_ID}
    
    gcloud container clusters create onlineboutique \
        --project=${PROJECT_ID} --zone=us-central1-b \
        --machine-type=e2-standard-4 --num-nodes=4
    ```

2. Install Istio on your cluster, enable Istio sidecar proxy injection in the `default` Kubernetes namespace, and apply all the manifests in the `/release` directory. This includes the Istio and Kubernetes manifests. 

   ```sh
   istioctl install --set profile=preview && \
   kubectl label namespace default istio-injection=enabled && \
   kubectl apply -f ./release 
   ```

3. Install LeakSignal (download yaml, find and replace API key)
   ```
   API_KEY="YOUR-API-KEY" \
   DEPLOYMENT_NAME="YOUR-DEPLOYMENT-NAME" \
   curl https://raw.githubusercontent.com/leaksignal/leaksignal/master/examples/istio/leaksignal.yaml | \
   envsubst | \
   kubectl apply -f -
   ```
4. Delete all the pods to enable LeakSignal
   ```
   kubectl delete --all pod
   ``` 
5. Run `kubectl get pods` to see pods are in a healthy and ready state. Wait for 2/2 on all pods.

6. Find the IP address of your Istio gateway Ingress or Service, and visit the
   application frontend in a web browser.

   ```sh
   INGRESS_HOST="$(kubectl -n istio-system get service istio-ingressgateway \
      -o jsonpath='{.status.loadBalancer.ingress[0].ip}')"
   echo "$INGRESS_HOST"
   ```
7. [View metrics in COMMAND](https://app.leaksignal.com).
