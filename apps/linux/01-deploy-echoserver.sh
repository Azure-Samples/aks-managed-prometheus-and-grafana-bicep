#!/bin/bash

# Variables
source 00-variables.sh

# Check if namespace exists in the cluster
result=$(kubectl get namespace -o jsonpath="{.items[?(@.metadata.name=='$demoNamespace')].metadata.name}")

if [[ -n $result ]]; then
  echo "[$demoNamespace] namespace already exists in the cluster"
else
  echo "[$demoNamespace] namespace does not exist in the cluster"
  echo "creating [$demoNamespace] namespace in the cluster..."
  kubectl create namespace $demoNamespace
fi

# Install testapi application
kubectl apply -f $deploymentTemplate -n $demoNamespace