---
# salt pillar file for Azure cloud settings

azure:
  enabled: False
  subscription_id: 'a0933dde-d634-4707-a3f1-70a2edd29fbf' # look on the "overview" page for your VM
  # https://apps.dev.microsoft.com/#/appList
  username: kf7xm@msn.com  # Microsoft Live Login info
  password: aPassWordGoesHere  # TODO: put in your genuine subscription information
  location: 'West US 2'
  resource_group: salt_azure_demo
...
