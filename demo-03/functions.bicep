param systemName string

@allowed([
  'dev'
  'test'
  'prod'
])
param environmentName string

param location string = resourceGroup().location

var defaultResourceName = toLower('${systemName}-${environmentName}')

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: toLower(replace(defaultResourceName, '-', ''))
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}
