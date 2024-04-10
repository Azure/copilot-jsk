// Execute this main file to depoy Azure AI studio resources in the basic security configuraiton

metadata name = 'Machine Learning Services Workspaces'
metadata description = 'This module deploys a Machine Learning Services Workspace.'
metadata owner = 'Azure/module-maintainers'
// Parameters

// @description('AI resources to deploy object.')
// // param aiResourceDeployment object 
// param aiResourceDeployment object = {
//   aiResource: {
//     name: 'ai-demo-hub-11'
//     projects: [
//       {
//         name: 'ai-demo-project'
//         kind: 'project'
//       }
//       // {
//       //   name: 'ai-demo-project-2'
//       //   kind: 'project'
//       // }
//     ]
//   }
// }

param resourceGroupName string = 'ai-demo-rg'
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

@description('Optional. Azure region used for the deployment of all resources.')
param location string = 'eastus'

@description('Optional. Set of tags to apply to all resources.')
param tags object = {}

// Variables
var name = toLower('${aiHubName}')

// Create a short, unique suffix, that will be unique to each resource group
var uniqueSuffix = substring(uniqueString(resourceGroup().id), 0, 4)

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
  tags: tags
}

// Dependent resources for the Azure Machine Learning workspace
module aiDependencies '../modules/dependencies/dependent-resources.bicep' = {
  name: 'dependencies-${name}-${uniqueSuffix}-deployment'
  params: {
    location: location
    resourceGroupName: resourceGroupName
    storageName: 'st${name}${uniqueSuffix}'
    keyvaultName: 'kv-${name}-${uniqueSuffix}'
    applicationInsightsName: 'appi-${name}-${uniqueSuffix}'
    containerRegistryName: 'cr${name}${uniqueSuffix}'
    aiServicesName: 'ais${name}${uniqueSuffix}'
    tags: tags
  }
}

module aiHub '../modules/aihub/ai-hub.bicep' = {
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
  }
}

module aiProject '../modules/aiproject/ai-project.bicep' = {
  name: 'ai-${aiProjectName}-deployment'
  params: {
    aiHubDescription: aiProjectDescription
    aiProjectName: 'ai-${aiProjectName}-${uniqueSuffix}'
    location:location
    // aiServicesId: aiDependencies.outputs.aiservicesID
    // aiServicesTarget: aiDependencies.outputs.aiservicesTarget
    tags: tags
    aiHubID: aiHub.outputs.aiHubID
  }
}
