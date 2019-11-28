### Check Aure CLI extension
az extension list
extensionName='azure-cli-ml'
az extension add --name ${extensionName} --verbose

### Create Resource Group
groupName='ps-aml'
groupLocation='Australia East'
group=$(az group create --name ${groupName} --location "${groupLocation}" --verbose)

### Deploy basic Azure ML Service workspace environment
amlName='ps-aml'
amlFriendlyName='Pluralsight Azure ML Workspace'
az ml workspace create \
    --workspace-name ${amlName} \
    --friendly-name ${amlFriendlyName}
    --resource-group $(echo $group | jq .name -r) \
    --location $(echo $group | jq .location -r) \
    --verbose

az group delete --name $(echo $group | jq .name -r) --yes --verbose