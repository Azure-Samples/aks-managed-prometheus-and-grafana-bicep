#!/bin/bash

# Variables
source ./00-variables.sh

# Check if namespace exists in the cluster
result=$(kubectl get namespace -o jsonpath="{.items[?(@.metadata.name=='$demoNamespace')].metadata.name}")

if [[ -n $result ]]; then
  echo "$demoNamespace namespace already exists in the cluster"
else
  echo "$demoNamespace namespace does not exist in the cluster"
  echo "creating $demoNamespace namespace in the cluster..."
  kubectl create namespace $demoNamespace
fi

# Install application
kubectl apply -f $demoTemplate -n $demoNamespace

# Check if horizontal pod autoscalers already exist for deployments
hpas=($(kubectl get hpa --namespace $demoNamespace -o=jsonpath='{$.items[*].metadata.name}' | grep $hpaName))

if ((${#hpas[@]} == 1)); then
  echo "The following horizontal pod autoscaler are already deployed in the $demoNamespace namespace:"
  for hpa in ${hpas[@]}; do
    echo " - $hpa"
  done
else
  echo "No horizontal pod autoscaler is deployed in the $demoNamespace namespace"
  echo "Deploying horizontal pod autoscalers for deployments in the $demoNamespace namespace..."

  # Autoscale deployments on CPU metric using the horizontal pod autoscaler
  kubectl autoscale deployment $deploymentName --namespace $demoNamespace --min=3 --max=10 --cpu-percent=50
fi
