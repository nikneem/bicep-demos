resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: 'my-app-service-plan'
  location: resourceGroup().location
  sku: {
    name: 'Standard'
  }
}

resource webApp 'Microsoft.Web/sites@2021-02-01' = {
  dependsOn: [
    appServicePlan
  ]
  name: 'my-web-app'
  location: resourceGroup().location
  properties: {
    serverFarmId: appServicePlan.id
  }
}
