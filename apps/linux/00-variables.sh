# Nginx Ingress Controller
nginxNamespace="ingress-basic"
nginxRepoName="ingress-nginx"
nginxRepoUrl="https://kubernetes.github.io/ingress-nginx"
nginxChartName="ingress-nginx"
nginxReleaseName="nginx-ingress"
nginxReplicaCount=3

# Variables
demoNamespace="echoserver"
deploymentTemplate="echoserver-deployment.yaml"
ingressName="echoserver"
ingressTemplate="echoserver-ingress.yaml"
dnsZoneName="babosbird.com"
dnsZoneResourceGroupName="DnsResourceGroup"
subdomain="tanecho"
host="$subdomain.$dnsZoneName"