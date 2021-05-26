#######################################
#
# Script to deploy simple PaaS solution
#
#######################################

### Authenticate to Azure
az login

### Define Deployment Variables
appNamePrefix='crf'
resourceGroupName="$appNamePrefix-simple-paas"
resourceGroupLocation='eastus'

resourceProviderNamespace='Microsoft.Web'
resourceTypeName='sites'

### Get ARM Provider Locations
query="resourceTypes[*].{Name:resourceType, Locations:locations}[?Name=='${resourceTypeName}']"
az provider show --namespace ${resourceProviderNamespace} --query ${query}

### Create ARM Resource Group
resourceGroup=$(az group create \
    --name ${resourceGroupName} \
    --location ${resourceGroupLocation} \
    --verbose)

### Create App Service Plan
resourceGroupId=$(echo $group | jq .id -r | shasum)
nameSuffix="${groupId:0:10}"
appServicePlanName="${appNamePrefix}-${nameSuffix}"

az appservice plan create \
    --resource-group ${resourceGroupName} \
    --name ${appServicePlanName} \
    --location ${resourceGroupLocation} \
    --sku S1 \
    --verbose

### Create Web App
webAppName="${appNamePrefix}-${nameSuffix}"

az webapp create \
    --resource-group ${resourceGroupName} \
    --name ${webAppName} \
    --location ${resourceGroupLocation} \
    --plan ${appServicePlanName} \
    --verbose
    