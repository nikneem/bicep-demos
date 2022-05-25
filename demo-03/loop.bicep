param queues array
param location string = resourceGroup().location

resource serviceBus 'Microsoft.ServiceBus/namespaces@2021-06-01-preview' = {
  name: 'servicebus-name'
  location: location
  sku: {
    name: 'Standard'
  }
}

resource serviceBusQueue 'Microsoft.ServiceBus/namespaces/queues@2021-06-01-preview' = [for queue in queues: {
  name: queue
  parent: serviceBus
}]
