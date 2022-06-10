param systemName string

@allowed([
  'dev'
  'test'
  'prod'
])
param environmentName string

param location string = resourceGroup().location

@secure()
param superSecretPassword string

var defaultResourceName = '${systemName}-${environmentName}'

module sqlServerModule 'Sql/servers.bicep' = {
  name: 'sqlServerModule'
  params: {
    defaultResourceName: defaultResourceName
    administratorPassword: superSecretPassword
    location: location
  }
}

module sqlDatabaseModule 'Sql/servers/databases.bicep' = {
  name: 'sqlDatabaseModule'
  dependsOn: [
    sqlServerModule
  ]
  params: {
    defaultResourceName: defaultResourceName
    sqlServerName: sqlServerModule.outputs.sqlServerName
    location: location
  }
}
