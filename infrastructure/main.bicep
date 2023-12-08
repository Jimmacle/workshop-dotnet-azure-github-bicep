@allowed(['dev', 'prod'])
param environment string

targetScope = 'resourceGroup'

module app './appservice.bicep' = {
  name: 'appservice'
  params: {
    appName: 'workshop-dnazghbicep-jimmacle'
    environment: environment
    location: 'centralus'
  }
}
