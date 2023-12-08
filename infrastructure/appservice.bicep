﻿param location string
@allowed(['dev', 'prod'])
param environment string
param appName string

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
      name: appName
      location: location
      sku: {
        name: 'S1'
      }
      kind: 'linux'
      properties: {
        reserved: true
      }
    }

resource appService 'Microsoft.Web/sites@2022-09-01' = {
    name: appName
    location: location
    identity: {
     type: 'SystemAssigned'
    }
    properties: {
       serverFarmId: appServicePlan.id
       httpsOnly: true
       siteConfig: {
         http20Enabled: true
         linuxFxVersion: 'DOTNETCORE|8.0'
         alwaysOn: true
         ftpsState: 'Disabled'
         minTlsVersion: '1.2'
         webSocketsEnabled: true
         healthCheckPath: '/api/healthz'
         requestTracingEnabled: true
         detailedErrorLoggingEnabled: true
         httpLoggingEnabled: true
       }
     }
 }

resource appSettings 'Microsoft.Web/sites/config@2022-09-01' = {
      name: 'appsettings'
      kind: 'string'
      parent: appService
      properties: {
          ASPNETCORE_ENVIRONMENT: 'dev'
      }
    }
    
resource appServiceSlot 'Microsoft.Web/sites/slots@2022-09-01' = {
      location: location
      parent: appService
      name: 'slot'
      identity: {
          type: 'SystemAssigned'
      }
      properties: {
          serverFarmId: appServicePlan.id
          httpsOnly: true
          siteConfig: {
             http20Enabled: true
             linuxFxVersion: 'DOTNETCORE|8.0'
             alwaysOn: true
             ftpsState: 'Disabled'
             minTlsVersion: '1.2'
             webSocketsEnabled: true
             healthCheckPath: '/api/healthz'
             requestTracingEnabled: true
             detailedErrorLoggingEnabled: true
             httpLoggingEnabled: true
          }
      }
   }
   
resource appServiceSlotSetting 'Microsoft.Web/sites/slots/config@2022-09-01' = {
   name: 'appsettings'
   kind: 'string'
   parent: appServiceSlot
   properties: {
     ASPNETCORE_ENVIRONMENT: 'dev'
   }
 }
