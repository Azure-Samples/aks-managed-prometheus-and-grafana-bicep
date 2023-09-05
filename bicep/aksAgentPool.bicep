// Parameters
@description('Specifies the name of the agent pool.')
param name string

@description('Specifies the mode of the agent pool.')
@allowed([
  'System'
  'User'
])
param mode string = 'User'

@description('Specifies the name of the AKS cluster.')
param aksClusterName string = 'aks-${uniqueString(resourceGroup().id)}'

@description('Specifies the availability zones for the agent pool.')
param availabilityZones array = []

@description('Specifies thr OS disk type of the agent pool.')
param osDiskType string

@description('Specifies the VM sku of the agent nodes.')
param vmSize string

@description('Specifies the disk size in GB of the agent nodes.')
param osDiskSizeGB int = 0

@description('Specifies whether to enable auto-scaling for the agent pool.')
param enableAutoScaling bool = true

@description('Specifies the number of agents for the user agent pool')
param count int = 1

@description('Specifies the minimum number of nodes for the user agent pool.')
param minCount int = 3

@description('Specifies the maximum number of nodes for the user agent pool.')
param maxCount int = 3

@description('Specifies the maximum number of pods per node.')
param maxPods int = 30

@description('Specifies the taints that should be applied to the agent pool.')
param nodeTaints array = []

@description('Specifies the labels that should be applied to the agent pool.')
param nodeLabels object = {}

@description('Specifies the OS Type for the agent pool.')
@allowed([
  'Linux'
  'Windows'
])
param osType string

@allowed([
  'Ubuntu'
  'Windows2019'
  'Windows2022'
  'AzureLinux'
])
param osSKU string

@description('Specifies whether assign a public IP per agent node.')
param enableNodePublicIP bool = false

@description('Specifies the name of the existing virtual network.')
param virtualNetworkName string

@description('Specifies the name of the subnet hosting the agent nodes of the agent pool.')
param vnetSubnetName string

@description('Specifies the name of the subnet hosting the pods running of the agent pool.')
param podSubnetName string

// Resources
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-08-01' existing = {
  name: virtualNetworkName
}

resource vnetSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-08-01' existing = {
  parent: virtualNetwork
  name: vnetSubnetName
}

resource podSubnet 'Microsoft.Network/virtualNetworks/subnets@2021-08-01' existing = {
  parent: virtualNetwork
  name: podSubnetName
}

resource aksCluster 'Microsoft.ContainerService/managedClusters@2023-06-02-preview' existing = {
  name: aksClusterName
}

resource agentPool 'Microsoft.ContainerService/managedClusters/agentPools@2023-06-02-preview' = {
  name: name
  parent: aksCluster
  properties: {
    mode: mode
    vmSize: vmSize
    count: count
    minCount: minCount
    maxCount: maxCount
    enableAutoScaling: enableAutoScaling
    availabilityZones: !empty(availabilityZones) ? availabilityZones : null
    osDiskSizeGB: osDiskSizeGB
    osDiskType: osDiskType
    osSKU: osSKU
    osType: osType
    maxPods: maxPods
    type: 'VirtualMachineScaleSets'
    vnetSubnetID: vnetSubnet.id
    podSubnetID: !empty(podSubnet.id) ? podSubnet.id : null
    nodeTaints: nodeTaints
    nodeLabels: nodeLabels
    enableNodePublicIP: enableNodePublicIP
  }
}

// Outputs
output name string = agentPool.name
output id string = agentPool.id
