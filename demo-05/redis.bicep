// az bicep publish --file redis.bicep --target br:your-acr.azurecr.io/bicep/modules/cache/redis:v1

param name string
param sku object

@allowed([
  'Disabled'
  'Enabled'
])
param publicNetworkAccess string = 'Disabled'

@allowed([
  true
  false
])
param enableNonSsl bool = false

resource redisCache 'Microsoft.Cache/redis@2020-12-01' = {
  name: name
  location: resourceGroup().location
  properties: {
    sku: sku
    enableNonSslPort: enableNonSsl
    publicNetworkAccess: publicNetworkAccess
  }
}

output primaryKey string = listKeys(redisCache.id, redisCache.apiVersion).primaryKey
