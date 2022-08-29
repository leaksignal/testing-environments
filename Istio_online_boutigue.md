
https://github.com/GoogleCloudPlatform/microservices-demo
Click the blue button to "Open in Google Cloud Shell"
This will copy the project source into GCP


From the cloudhsell console run the following...

$> PROJECT_ID="leaksignal" && ZONE=us-central1-b
$> gcloud container clusters create onlineboutique \
    --project=${PROJECT_ID} --zone=${ZONE} \
    --machine-type=e2-standard-4 --num-nodes=4
    
#Install Istio and apply yaml files
$> istioctl install --set profile=preview && \
$> kubectl label namespace default istio-injection=enabled && \
$> kubectl apply -f ./release

#Install LeakSignal
$> curl -N https://gist.githubusercontent.com/wesleyhales/5c9aed50f47d5eeaa95b14d79292b373/raw/487e0e11dfb18bf5e643aa659b7b3ccd94b3b4f6/leaksignal.yaml | \
 sed 's/api_key_placeholder/replace_with_your_api_key/g' | \
 sed 's/deployment_name_placeholder/replace_with_your_deployment_name/g' | \
 kubectl apply -f -

#restart all the pods
$> kubectl delete --all pod
$> kubectl get pods (wait for all services to show 2/2 and no errors)

#get the public IP address and visit in web browser
$> INGRESS_HOST="$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')"
$> echo "$INGRESS_HOST"
