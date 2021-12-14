module stg 'br:your-acr.azurecr.io/bicep/modules/cache/redis:v2' = {
  name: 'storageDeploy'
  params: {
    name: 'cachename'
    sku: {
      name: 'Basic'
      family: 'C'
      capacity: 0
    }
  }
}
