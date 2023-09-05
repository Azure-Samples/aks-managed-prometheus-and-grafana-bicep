# NGINX Ingress Controller
# Nginx Ingress Controller
nginxNamespace="ingress-basic"
nginxRepoName="ingress-nginx"
nginxRepoUrl="https://kubernetes.github.io/ingress-nginx"
nginxChartName="ingress-nginx"
nginxReleaseName="nginx-ingress"
nginxReplicaCount=3

# Certificate Manager
cmNamespace="cert-manager"
cmRepoName="jetstack"
cmRepoUrl="https://charts.jetstack.io"
cmChartName="cert-manager"
cmReleaseName="cert-manager"

# Cluster Issuer
email="paolos@microsoft.com"
clusterIssuerName="letsencrypt-nginx"
clusterIssuerTemplate="cluster-issuer.yaml"

# Workload
demoNamespace="iis"
demoTemplate="deployment.yaml"
hpaName="httpbin"

# Ingress and DNS
ingressTemplate="ingress.yaml"
deploymentName="sample"
ingressName="sample"
dnsZoneName="babosbird.com"
dnsZoneResourceGroupName="DnsResourceGroup"
subdomain="taniis"
host="$subdomain.$dnsZoneName"

# Http Scaled Object
httpScaledObjectTemplate="httpscaledobject.yaml"
minReplicas=1
maxReplicas=10