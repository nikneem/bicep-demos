param defaultResourceName string

var resourceName = '${defaultResourceName}-ai'

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: resourceName
  location: resourceGroup().location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

output applicationInsightsName string = applicationInsights.name
output instrumentationKey string = applicationInsights.properties.InstrumentationKey
output appConfiguration array = [
  {
    name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
    value: applicationInsights.properties.InstrumentationKey
  }
]
