// Execute this main file to depoy Azure AI studio resources in the basic security configuraiton
metadata name = 'Azure OpenAI Studio Deployment'
metadata description = 'Azure OpenAI Studio Deployment'

@minLength(2)
@maxLength(12)
@description('Optional. Prefix name for the AI resource and used to derive name of dependent resources.')
param aiHubName string = 'air6-demo'

@minLength(2)
@maxLength(12)
@description('Optional. Name for the AI resource and used to derive name of dependent resources.')
param aiProjectName string = 'aitest-pjct'

@description('Optional. Friendly name for your Azure AI resource')
param aiHubFriendlyName string = 'Demo AI resource'

@description('Optional. Description of your Azure AI resource dispayed in AI studio')
param aiHubDescription string = 'This is an example AI resource for use in Azure AI Studio.'

@description('Optional. Description of your Azure AI resource dispayed in AI studio')
param aiProjectDescription string = 'This is an example AI project for.'

@description('Optional. Friendly name for your Azure AI resource')
param aiProjectFriendlyName string = 'DemoProject AI resource'

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Set of tags to apply to all resources.')
param tags object = {}

@description('Optional. Compute instance name.')
param computeInstanceName string = 'air6DemoCompute'

@description('Optional. Compute instance Virtual Machine Size.')
param vmSize string = 'Standard_DS11_v2'

// Variables
var name = toLower('${aiHubName}')

// Create a short, unique suffix, that will be unique to each resource group
var uniqueSuffix = substring(uniqueString(resourceGroup().id), 0, 4)

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
    applicationInsightsId: aiDependencies.outputs.applicationInsightsId
    containerRegistryId: aiDependencies.outputs.containerRegistryId
    keyVaultId: aiDependencies.outputs.keyvaultId
    storageAccountId: aiDependencies.outputs.storageId

    // compute resources
    computeInstanceName: computeInstanceName
    vmSize: vmSize
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
