param systemName string

@allowed([
  'dev'
  'test'
  'prod'
])
param environmentName string

var defaultResourceName = '${systemName}-${environmentName}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: toLower(replace(defaultResourceName, '-', ''))
  location: resourceGroup().location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}
