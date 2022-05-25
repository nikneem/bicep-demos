param location string = resourceGroup().location

param queues array = [
  'queue1'
  'queue2'
]

module sb 'loop.bicep' = {
  name: 'sbModule'
  params: {
    queues: queues
    location: location
  }
}
