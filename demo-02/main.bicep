param systemName string

@allowed([
  'dev'
  'test'
  'prod'
])
param environmentName string

@secure()
param superSecretPassword string

var defaultResourceName = '${systemName}-${environmentName}'

module sqlServerModule 'Sql/servers.bicep' = {
  name: 'sqlServerModule'
  params: {
    defaultResourceName: defaultResourceName
    administratorPassword: superSecretPassword
  }
}

module sqlDatabaseModule 'Sql/servers/databases.bicep' = {
  name: 'sqlDatabaseModule'
  params: {
    defaultResourceName: defaultResourceName
    sqlServerName: sqlServerModule.outputs.sqlServerName
  }
}
