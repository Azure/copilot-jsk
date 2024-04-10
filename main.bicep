// Execute this main file to depoy Azure AI studio resources in the basic security configuraiton
metadata name = 'Azure OpenAI Studio Deployment'
metadata description = 'Azure OpenAI Studio Deployment'


@minLength(2)
@maxLength(12)
@description('Name for the AI resource and used to derive name of dependent resources.')
param aiHubName string = 'air6-demo'

@minLength(2)
@maxLength(12)
@description('Name for the AI resource and used to derive name of dependent resources.')
param aiProjectName string = 'aitest-pjct'

@description('Friendly name for your Azure AI resource')
param aiHubFriendlyName string = 'Demo AI resource'

@description('Description of your Azure AI resource dispayed in AI studio')
param aiHubDescription string = 'This is an example AI resource for use in Azure AI Studio.'

@description('Description of your Azure AI resource dispayed in AI studio')
param aiProjectDescription string = 'This is an example AI project for.'

@description('Friendly name for your Azure AI resource')
param aiProjectFriendlyName string = 'DemoProject AI resource'

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Set of tags to apply to all resources.')
param tags object = {}


param adminUserName string = ''
param computeInstanceName string = ''
param disableLocalAuth bool = false
param idleTimeBeforeShutdown string = '60'
param rootAccess bool = false
param workspaceName string = ''

// Variables
var name = toLower('${aiHubName}')

// Create a short, unique suffix, that will be unique to each resource group
var uniqueSuffix = substring(uniqueString(resourceGroup().id), 0, 4)

// module aiNetwork 'modules/dependencies/virtual-network/virtual-network.bicep' = {
//   name: 'network-${name}-${uniqueSuffix}-deployment'
//   params: {
//     location: location
//     virtualNetworkName: 'vnet-${name}-${uniqueSuffix}'
//   }
// }

// Dependent resources for the Azure Machine Learning workspace
module aiDependencies 'modules/dependencies/dependent-resources.bicep' = {
  name: 'dependencies-${name}-${uniqueSuffix}-deployment'
  params: {
    location: location
    storageName: 'st${name}${uniqueSuffix}'
    keyvaultName: 'kv-${name}-${uniqueSuffix}'
    applicationInsightsName: 'appi-${name}-${uniqueSuffix}'
    containerRegistryName: 'cr${name}${uniqueSuffix}'
    aiServicesName: 'ais${name}${uniqueSuffix}'
    tags: tags
  }
}

module aiHub 'modules/aihub/ai-hub.bicep' = {
  name: 'ai-${aiHubName}-deployment'
  params: {
    // workspace organization
    aiHubName: 'ai-${aiHubName}-${uniqueSuffix}'
    aiHubFriendlyName: aiHubFriendlyName
    aiHubDescription: aiHubDescription
    location: location
    tags: tags

    // dependent resources
    aiServicesId: aiDependencies.outputs.aiservicesID
    aiServicesTarget: aiDependencies.outputs.aiservicesTarget
    applicationInsightsId: aiDependencies.outputs.applicationInsightsId
    containerRegistryId: aiDependencies.outputs.containerRegistryId
    keyVaultId: aiDependencies.outputs.keyvaultId
    storageAccountId: aiDependencies.outputs.storageId

    // compute resources
    adminUserName: adminUserName
    computeInstanceName: computeInstanceName
    disableLocalAuth: disableLocalAuth
    idleTimeBeforeShutdown: idleTimeBeforeShutdown
    rootAccess: rootAccess
    workspaceName: workspaceName
    // subnetResourceID: aiDependencies.outputs.subnetResourceId
  }
}

module aiProject 'modules/aiproject/ai-project.bicep' = {
  name: 'ai-${aiProjectName}-deployment'
  params: {
    aiHubDescription: aiProjectDescription
    aiProjectFriendlyName: aiProjectFriendlyName
    aiProjectName: 'ai-${aiProjectName}-${uniqueSuffix}'
    location:location
    tags: tags
    aiHubID: aiHub.outputs.aiHubID
  }
}
