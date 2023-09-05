#!/bin/bash

# Variables
location="WestEurope"
resourceGroupName="MikiRG"
aksClusterName="MikiAks"
nodePoolName="w2022e"
vmSize="Standard_D8ds_v4"
osType="Windows"
osSku="Windows2022"
osDiskSize=128
osDiskType="Ephemeral"
nodeCount=1
minCount=1
maxCount=3
maxPods=100
mode="User"
podSubnetId="/subscriptions/1a45a694-ae23-4650-9774-89a571c462f6/resourceGroups/MikiRG/providers/Microsoft.Network/virtualNetworks/MikiAksVnet/subnets/PodSubnet"

az aks nodepool show \
  --name $nodePoolName \
  --cluster-name $aksClusterName \
  --resource-group $resourceGroupName &>/dev/null

if [[ $? == 0 ]]; then
  echo "A node pool called [$nodePoolName] already exists in the [$aksClusterName] AKS cluster"
else
  echo "No node pool called [$nodePoolName] actually exists in the [$aksClusterName] AKS cluster"

  # Get the last Kubernetes version available in the region
  kubernetesVersion=$(az aks get-versions --location $location --query "orchestrators[?isPreview==false].orchestratorVersion | sort(@) | [-1]" --output tsv)

  if [[ -n $kubernetesVersion ]]; then
    echo "Successfully retrieved the last Kubernetes version [$kubernetesVersion] supported by AKS in [$location] Azure region"
  else
    echo "Failed to retrieve the last Kubernetes version supported by AKS in [$location] Azure region"
    exit
  fi

  echo "Creating [$nodePoolName] node pool in the [$aksClusterName] AKS cluster..."

  if [[ -n $podSubnetId ]]; then
    az aks nodepool add \
      --name $nodePoolName \
      --mode $mode \
      --cluster-name $aksClusterName \
      --resource-group $resourceGroupName \
      --kubernetes-version $kubernetesVersion \
      --enable-cluster-autoscaler \
      --os-type $osType \
      --os-sku $osSku \
      --node-vm-size $vmSize \
      --node-osdisk-size $osDiskSize \
      --node-osdisk-type $osDiskType \
      --node-count $nodeCount \
      --min-count $minCount \
      --max-count $maxCount \
      --max-pods $maxPods \
      --tags osDiskType=ephemeral osType=Windows2022 \
      --labels osDiskType=ephemeral osType=Windows2022 \
      --node-taints windows=true:NoSchedule \
      --pod-subnet-id $podSubnetId \
    --zones 1 2 3 1>/dev/null
  else

    az aks nodepool add \
      --name $nodePoolName \
      --mode $mode \
      --cluster-name $aksClusterName \
      --resource-group $resourceGroupName \
      --kubernetes-version $kubernetesVersion \
      --enable-cluster-autoscaler \
      --os-type $osType \
      --os-sku $osSku \
      --node-vm-size $vmSize \
      --node-osdisk-size $osDiskSize \
      --node-osdisk-type $osDiskType \
      --node-count $nodeCount \
      --min-count $minCount \
      --max-count $maxCount \
      --max-pods $maxPods \
      --tags osDiskType=ephemeral osType=Windows2022 \
      --labels osDiskType=ephemeral osType=Windows2022 \
      --node-taints os=windows:NoSchedule \
      --pod-
    --zones 1 2 3 1>/dev/null
  fi

  if [[ $? == 0 ]]; then
    echo "[$nodePoolName] node pool successfully created in the [$aksClusterName] AKS cluster"
  else
    echo "Failed to create the [$nodePoolName] node pool in the [$aksClusterName] AKS cluster"
  fi
fi
