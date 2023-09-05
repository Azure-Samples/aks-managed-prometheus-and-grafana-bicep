#/bin/bash

# Variables
source ./00-variables.sh

# Check if the ingress already exists
result=$(kubectl get ingress -n $demoNamespace -o json | jq -r '.items[].metadata.name | select(. == "'$ingressName'")')

if [[ -n $result ]]; then
  echo "[$ingressName] ingress already exists"
else
  # Create the ingress
  echo "[$ingressName] ingress does not exist"
  echo "Creating [$ingressName] ingress..."
  cat $ingressTemplate |
    yq "(.spec.tls[0].hosts[0])|="\""$host"\" |
    yq "(.spec.rules[0].host)|="\""$host"\" |
    kubectl apply -n $demoNamespace -f -
fi
