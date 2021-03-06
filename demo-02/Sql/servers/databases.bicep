param defaultResourceName string
param sqlServerName string
param location string = resourceGroup().location

param sku object = {
  name: 'Standard'
  tier: 'Standard'
  capacity: 10
}

var resourceName = '${defaultResourceName}-sqldb'

resource database 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  location: location
  name: '${sqlServerName}/${resourceName}'
  sku: sku
  properties: {}
}
