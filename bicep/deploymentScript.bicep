// For more information, see https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-script-bicep
@description('Specifies the name of the deployment script uri.')
param name string = 'BashScript' 

@description('Specifies the name of the user-defined managed identity used by the deployment script.')
param managedIdentityName string = 'ScriptManagedIdentity' 

@description('Specifies the primary script URI.')
param primaryScriptUri string

@description('Specifies the name of the AKS cluster.')
param clusterName string

@description('Specifies the resource group name')
param resourceGroupName string = resourceGroup().name

@description('Specifies the Azure AD tenant id.')
param tenantId string = subscription().tenantId

@description('Specifies the subscription id.')
param subscriptionId string = subscription().subscriptionId

@description('Specifies whether creating the Application Gateway and enabling the Application Gateway Ingress Controller or not.')
param applicationGatewayEnabled string

@description('Specifies the hostname of the application.')
param hostName string

@description('Specifies the namespace of the application.')
param namespace string

@description('Specifies the service account of the application.')
param serviceAccountName string = 'magic8ball-sa'

@description('Specifies the client id of the workload user-defined managed identity.')
param workloadManagedIdentityClientId string

@description('Specifies the email address for the cert-manager cluster issuer.')
param email string = 'admin@contoso.com'

@description('Specifies the current datetime')
param utcValue string = utcNow()

@description('Specifies the location.')
param location string = resourceGroup().location

@description('Specifies the resource tags.')
param tags object

// Resources
resource clusterAdminRole 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  name: '0ab0b1a8-8aac-4efd-b8c2-3ee1fb270be8'
  scope: subscription()
}

resource aksCluster 'Microsoft.ContainerService/managedClusters@2022-11-02-preview' existing = {
  name: clusterName
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: managedIdentityName
  location: location
  tags: tags
}

resource clusterAdminContributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name:  guid(managedIdentity.id, aksCluster.id, clusterAdminRole.id)
  scope: aksCluster
  properties: {
    roleDefinitionId: clusterAdminRole.id
    principalId: managedIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

// Script
resource deploymentScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: name
  location: location
  kind: 'AzureCLI'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentity.id}': {}
    }
  }
  properties: {
    forceUpdateTag: utcValue
    azCliVersion: '2.42.0'
    timeout: 'PT30M'
    environmentVariables: [
      {
        name: 'clusterName'
        value: clusterName
      }
      {
        name: 'resourceGroupName'
        value: resourceGroupName
      }
      {
        name: 'applicationGatewayEnabled'
        value: applicationGatewayEnabled
      }
      {
        name: 'tenantId'
        value: tenantId
      }
      {
        name: 'subscriptionId'
        value: subscriptionId
      }
      {
        name: 'hostName'
        value: hostName
      }
      {
        name: 'namespace'
        value: namespace
      }
      {
        name: 'serviceAccountName'
        value: serviceAccountName
      }
      {
        name: 'workloadManagedIdentityClientId'
        value: workloadManagedIdentityClientId
      }
      {
        name: 'email'
        value: email
      }
    ]
    primaryScriptUri: primaryScriptUri
    cleanupPreference: 'OnSuccess'
    retentionInterval: 'P1D'
  }
}

// Outputs
output result object = deploymentScript.properties.outputs
output certManager string = deploymentScript.properties.outputs.certManager
output nginxIngressController string = deploymentScript.properties.outputs.nginxIngressController
