param defaultResourceName string

param administratorUsername string = ''
@secure()
param administratorPassword string = newGuid()

var resourceName = '${defaultResourceName}-sql'
var administratorLogin = administratorUsername ?? '${defaultResourceName}-admin'
var dbName = '${defaultResourceName}-sqldb'
var connectionString = 'DATA SOURCE=tcp:${resourceName}${environment().suffixes.sqlServerHostname},1433;USER ID=${administratorUsername};PASSWORD=${administratorPassword};INITIAL CATALOG=${dbName};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;'

resource sqlServer 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: resourceName
  location: resourceGroup().location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorPassword
    publicNetworkAccess: 'Enabled'
  }
}

resource symbolicname 'Microsoft.Sql/servers/firewallRules@2021-02-01-preview' = {
  name: '${sqlServer.name}/azure-datacenter'
  properties: {
    endIpAddress: '0.0.0.0'
    startIpAddress: '0.0.0.0'
  }
}

output sqlServerName string = sqlServer.name
output sqlServerLogin string = administratorLogin
output sqlServerPassword string = administratorPassword
output secret object = {
  name: 'SqlConnectionString'
  value: connectionString
}
