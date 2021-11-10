param defaultResourceName string

@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GRS'
  'Standard_GZRS'
  'Standard_LRS'
  'Standard_RAGRS'
  'Standard_RAGZRS'
  'Standard_ZRS'
])
param skuName string

var resourceName = toLower(replace(defaultResourceName, '-', ''))

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: resourceName
  kind: 'StorageV2'
  location: resourceGroup().location
  sku: {
    name: skuName
  }
}

output connectionString string = 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'
output secret object = {
  name: 'AzureStorageAccount'
  value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'
}
output secretName string = 'StorageAccountConnectionString'
output storageAccountName string = storageAccount.name
