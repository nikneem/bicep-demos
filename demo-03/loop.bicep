param queues array

resource serviceBus 'Microsoft.ServiceBus/namespaces@2021-06-01-preview' = {
  name: 'servicebus-name'
  location: resourceGroup().location
  sku: {
    name: 'Standard'
  }
}

resource serviceBusQueue 'Microsoft.ServiceBus/namespaces/queues@2021-06-01-preview' = [for queue in queues: {
  name: queue
  parent: serviceBus
}]
