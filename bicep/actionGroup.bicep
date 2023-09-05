// Parameters
@description('Specifies the name of the Action Group resource.')
param name string

@description('Specifies the short name of the action group. This will be used in SMS messages..')
param groupShortName string = 'AksAlerts'

@description('Specifies whether this action group is enabled. If an action group is not enabled, then none of its receivers will receive communications.')
param enabled bool = true

@description('Specifies the email address of the receiver.')
param emailAddress string

@description('Specifies whether to use common alert schema..')
param useCommonAlertSchema bool = false

@description('Specifies the country code of the SMS receiver.')
param countryCode string = '39'

@description('Specifies the phone number of the SMS receiver.')
param phoneNumber string = ''

@description('Specifies the resource tags.')
param tags object

// Resources
resource actionGroup 'Microsoft.Insights/actionGroups@2023-01-01' = {
  name: name
  location: 'Global'
  tags: tags
  properties: {
    groupShortName: groupShortName
    enabled: enabled
    emailReceivers: !empty(emailAddress) ? [
      {
        name: 'EmailAndTextMessageOthers_-EmailAction-'
        emailAddress: emailAddress
        useCommonAlertSchema: useCommonAlertSchema
      }
    ] : []
    smsReceivers: !empty(countryCode) && !empty(phoneNumber) ? [
      {
        name: 'EmailAndTextMessageOthers_-SMSAction-'
        countryCode: countryCode
        phoneNumber: phoneNumber
      }
    ] : []
    armRoleReceivers: [
      {
        name: 'EmailOwner'
        roleId: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
        useCommonAlertSchema: false
      }
    ]
  }
}

//Outputs
output id string = actionGroup.id
output name string = actionGroup.name
