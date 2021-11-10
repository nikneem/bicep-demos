param defaultResourceName string
param sqlServerName string
param sqlServerLogin string
@secure()
param sqlServerPassword string

param sku object = {
  name: 'Standard'
  tier: 'Standard'
  capacity: 10
}

var resourceName = '${defaultResourceName}-sqldb'

var calculatedConnectionString = 'DATA SOURCE=tcp:${sqlServerName}${environment().suffixes.sqlServerHostname},1433;USER ID=${sqlServerLogin};PASSWORD=${sqlServerPassword};INITIAL CATALOG=${resourceName};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;'

resource database 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  location: resourceGroup().location
  name: '${sqlServerName}/${resourceName}'
  sku: sku
  properties: {}
}

output connectionString string = calculatedConnectionString
output secret array = [
  {
    name: database.name
    value: calculatedConnectionString
  }
]
output secretName string = 'SqlServerConnectionString'
output databaseName string = defaultResourceName
