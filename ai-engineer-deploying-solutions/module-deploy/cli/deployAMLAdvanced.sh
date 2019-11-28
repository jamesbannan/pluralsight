### Check Aure CLI extension
az extension list
extensions=( azure-cli-ml application-insights )

for i in "${extensions[@]}"
do
	az extension add --name ${i} --verbose
done

### Create Resource Group
groupName='ps-aml'
groupLocation='Australia East'
group=$(az group create --name ${groupName} --location "${groupLocation}" --verbose)
groupId=$(echo $group | jq .id -r | shasum)

### Deploy advanced Azure ML Service workspace environment
amlName='ps-aml'
amlFriendlyName='Pluralsight Azure ML Workspace'

# Deploy Application Insights
appinsights=$(az resource create \
    --resource-group $(echo $group | jq .name -r) \
    --resource-type "Microsoft.Insights/components" \
    --name ${amlName}-appinsights \
    --location $(echo $group | jq .location -r) \
    --properties '{"Application_Type":"web"}' \
    )

# Deploy Key Vault
nameSuffix="${groupId:0:10}"
vault=$(az keyvault create \
    --resource-group $(echo $group | jq .name -r) \
    --name ${amlName}-vault-${nameSuffix} \
    --location $(echo $group | jq .location -r) \
    --sku standard \
    --verbose \
    )

# Deploy Storage Account
storage=$(az storage account create \
    --resource-group $(echo $group | jq .name -r) \
    --name psaml${nameSuffix} \
    --location $(echo $group | jq .location -r) \
    --kind StorageV2 \
    --sku Standard_LRS \
    --verbose \
    )

# Deploy Container Registry
acr=$(az acr create \
    --resource-group $(echo $group | jq .name -r) \
    --name psamlcr${nameSuffix} \
    --location $(echo $group | jq .location -r) \
    --sku Basic \
    --admin-enabled true \
    --verbose \
    )

# Deploy AML workspace
az ml workspace create \
    --workspace-name ${amlName} \
    --friendly-name ${amlFriendlyName} \
    --resource-group $(echo $group | jq .name -r) \
    --location $(echo $group | jq .location -r) \
    --application-insights $(echo $appinsights | jq .id -r) \
    --container-registry $(echo $acr | jq .id -r) \
    --keyvault $(echo $vault | jq .id -r) \
    --storage-account $(echo $storage | jq .id -r) \
    --verbose

az group delete --name $(echo $group | jq .name -r) --yes --verbose