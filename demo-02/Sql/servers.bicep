param defaultResourceName string

param administratorUsername string = ''
@secure()
param administratorPassword string = newGuid()

var resourceName = '${defaultResourceName}-sql'
var administratorLogin = administratorUsername ?? '${defaultResourceName}-admin'

resource sqlServer 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: resourceName
  location: resourceGroup().location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorPassword
    publicNetworkAccess: 'Disabled'
  }
}

output sqlServerName string = sqlServer.name
output sqlServerLogin string = administratorLogin
output sqlServerPassword string = administratorPassword
