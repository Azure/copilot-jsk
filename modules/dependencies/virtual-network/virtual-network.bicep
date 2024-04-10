@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Storage Account Blob endpoint name')
param storageAccountName string

@description('Storage Account Blob endpoint name')
param storage string

@description('Machine learning workspace private link endpoint name')
param machineLearningPleName string = 'mlpe'

// @description('Resource ID of the machine learning workspace')
// param workspaceArmId string

var addressPrefix = '10.0.0.0/16'

var privateDnsZoneName =  {
  azureusgovernment: 'privatelink.api.ml.azure.us'
  azurechinacloud: 'privatelink.api.ml.azure.cn'
  azurecloud: 'privatelink.api.azureml.ms'
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: 'defaultSubnet'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 16, 0)
        }
      }
    ]
  }
}

resource privateDNSZoneKeyVault 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.vaultcore.azure.net'
  location: 'global'

  resource virtualNetworkLinks 'virtualNetworkLinks@2020-06-01' = {
    name: '${virtualNetwork.name}-vnetlink'
    location: 'global'
    properties: {
      virtualNetwork: {
        id: virtualNetwork.id
      }
      registrationEnabled: false
    }
  }
}

resource privateDNSZoneStorageBlob 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.blob.core.azure.net'
  location: 'global'

  resource virtualNetworkLinks 'virtualNetworkLinks@2020-06-01' = {
    name: '${virtualNetwork.name}-vnetlink'
    location: 'global'
    properties: {
      virtualNetwork: {
        id: virtualNetwork.id
      }
      registrationEnabled: false
    }
  }
}

resource privateDNSZoneStorageFile 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.file.core.azure.net'
  location: 'global'

  resource virtualNetworkLinks 'virtualNetworkLinks@2020-06-01' = {
    name: '${virtualNetwork.name}-vnetlink'
    location: 'global'
    properties: {
      virtualNetwork: {
        id: virtualNetwork.id
      }
      registrationEnabled: false
    }
  }
}

resource privateDNSZoneML 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.api.azureml.ms'
  location: 'global'

  resource virtualNetworkLinks 'virtualNetworkLinks@2020-06-01' = {
    name: '${virtualNetwork.name}-vnetlink'
    location: 'global'
    properties: {
      virtualNetwork: {
        id: virtualNetwork.id
      }
      registrationEnabled: false
    }
  }
}

resource sablobpe 'Microsoft.Network/privateEndpoints@2023-05-01' = {
  name: '${storageAccountName}-blobpe'
  location: location
  properties:{
    subnet: {
      id: virtualNetwork.properties.subnets[0].id
    }
    privateLinkServiceConnections: [
    {
      name: '${storageAccountName}-blobpe-conn'
      properties: {
        privateLinkServiceId: storage
        groupIds:[
          'blob'
        ]
        privateLinkServiceConnectionState: {
          status: 'Approved'
          actionsRequired: 'None'
        }
      }
    }
    ]
  }
}

// resource machineLearningPrivateEndpoint 'Microsoft.Network/privateEndpoints@2022-01-01' = {
//   name: machineLearningPleName
//   location: location
//   properties: {
//     privateLinkServiceConnections: [
//       {
//         name: machineLearningPleName
//         properties: {
//           groupIds: [
//             'amlworkspace'
//           ]
//           privateLinkServiceId: aiHub
//         }
//       }
//     ]
//     subnet: {
//       id: virtualNetwork.properties.subnets[0].id
//     }
//   }
// }

// resource amlPrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
//   name: privateDnsZoneName[toLower(environment().name)]
//   location: 'global'

//   resource amlPrivateDnsZoneVnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
//     name: '${amlPrivateDnsZone.name}/${uniqueString(workspaceArmId)}'
//     location: 'global'
//     properties: {
//       registrationEnabled: false
//       virtualNetwork: {
//         id: virtualNetwork.id
//       }
//     }
//   }
// }

@description('The resource ID of the created Virtual Network Subnet.')
output vnetResourceId string = virtualNetwork.id

@description('The resource ID of the created Virtual Network Subnet.')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id

@description('The resource ID of the created Private DNS Zone.')
output privateDNSZoneKeyVaultResourceId string = privateDNSZoneKeyVault.id

@description('The resource ID of the created Private DNS Zone.')
output privateDNSZoneStorageBlobResourceId string = privateDNSZoneStorageBlob.id

@description('The resource ID of the created Private DNS Zone.')
output privateDNSZoneStorageFileResourceId string = privateDNSZoneStorageFile.id

@description('The resource ID of the created Private DNS Zone.')
output privateDNSZoneMLResourceId string = privateDNSZoneML.id
