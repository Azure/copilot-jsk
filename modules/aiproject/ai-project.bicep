// Creates an Azure AI resource with proxied endpoints for the Azure AI services provider

@description('Azure region of the deployment')
param location string

@description('Tags to add to the resources')
param tags object

@description('AI hub name')
param aiProjectName string

@description('AI hub display name')
param aiProjectFriendlyName string

@description('AI hub description')
param aiHubDescription string

@description('Resource ID of the AI Services Hub')
param aiHubID string

resource aiProject 'Microsoft.MachineLearningServices/workspaces@2023-08-01-preview' = {
  name: aiProjectName
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    // organization
    friendlyName: aiProjectFriendlyName
    description: aiHubDescription

    // dependent resources
    hubResourceId: aiHubID
  }
  kind: 'project'
}

output aiProjectID string = aiProject.id
