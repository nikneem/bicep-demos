targetScope = 'subscription'

@maxLength(8)
param serviceName string
@maxLength(3)
param locationAbbreviation string
@allowed([
  'Dev'
  'Test'
  'Acc'
  'Prod'
])
param environmentName string

param location string = deployment().location

param basicAppSettings array = [
  {
    name: 'WEBSITE_RUN_FROM_PACKAGE'
    value: '1'
  }
]

@secure()
param sqlServerPassword string
param sqlServerUsername string

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
param storageAccountSku string = 'Standard_LRS'

param sqlServerDatabaseSku object = {
  name: 'Standard'
  tier: 'Standard'
  capacity: 10
}

var resourceGroupName = toLower('${serviceName}-${environmentName}-${locationAbbreviation}')
var defaultResourceName = toLower('${serviceName}-${environmentName}-${locationAbbreviation}')

resource targetResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module applicationInsightModule 'Insights/components.bicep' = {
  name: 'applicationInsightModule'
  scope: targetResourceGroup
  params: {
    defaultResourceName: defaultResourceName
  }
}

module storageAccountModule 'Storage/storageAccounts.bicep' = {
  name: 'storageModule'
  scope: targetResourceGroup
  params: {
    defaultResourceName: defaultResourceName
    skuName: storageAccountSku
  }
}

module appServicePlan 'Web/serverFarms.bicep' = {
  name: 'appServicePlan'
  scope: targetResourceGroup
  params: {
    defaultResourceName: defaultResourceName
  }
}

module webAppModule 'Web/sites.bicep' = {
  name: 'webAppModule'
  scope: targetResourceGroup
  params: {
    defaultResourceName: defaultResourceName
    appServicePlanId: appServicePlan.outputs.id
  }
}

module keyVaultModule 'KeyVault/vault.bicep' = {
  name: 'keyVaultModule'
  scope: targetResourceGroup
  params: {
    defaultResourceName: defaultResourceName
  }
}

module sqlServerModule 'Sql/servers.bicep' = {
  name: 'sqlServerModule'
  scope: targetResourceGroup
  params: {
    defaultResourceName: defaultResourceName
    administratorPassword: sqlServerPassword
    administratorUsername: sqlServerUsername
  }
}

module sqlServerDatabaseModule 'Sql/servers/database.bicep' = {
  name: 'sqlServerDatabaseModule'
  scope: targetResourceGroup
  params: {
    sku: sqlServerDatabaseSku
    defaultResourceName: defaultResourceName
    sqlServerLogin: sqlServerModule.outputs.sqlServerLogin
    sqlServerPassword: sqlServerModule.outputs.sqlServerPassword
    sqlServerName: sqlServerModule.outputs.sqlServerName
  }
}

module storageAccountSecretModule 'KeyVault/vaults/secrets.bicep' = {
  dependsOn: [
    keyVaultModule
    storageAccountModule
  ]
  name: 'storageAccountSecretModule'
  scope: targetResourceGroup
  params: {
    keyVault: keyVaultModule.outputs.keyVaultName
    secret: storageAccountModule.outputs.secret
  }
}

module sqlServerSecretModule 'KeyVault/vaults/secrets.bicep' = {
  dependsOn: [
    keyVaultModule
    sqlServerModule
  ]
  name: 'sqlServerSecretModule'
  scope: targetResourceGroup
  params: {
    keyVault: keyVaultModule.outputs.keyVaultName
    secret: sqlServerModule.outputs.secret
  }
}

module keyVaultAccessPolicyModule 'KeyVault/vaults/accessPolicies.bicep' = {
  name: 'keyVaultAccessPolicyDeploy'
  dependsOn: [
    keyVaultModule
    webAppModule
  ]
  scope: targetResourceGroup
  params: {
    keyVaultName: keyVaultModule.outputs.keyVaultName
    principalId: webAppModule.outputs.servicePrincipal
  }
}

module websiteConfiguration 'Web/sites/config.bicep' = {
  name: 'websiteConfiguration'
  dependsOn: [
    keyVaultModule
    keyVaultAccessPolicyModule
  ]
  scope: targetResourceGroup
  params: {
    webAppName: webAppModule.outputs.webAppName
    appSettings: union(basicAppSettings, applicationInsightModule.outputs.appConfiguration, storageAccountSecretModule.outputs.keyVaultReference, sqlServerSecretModule.outputs.keyVaultReference)
  }
}
