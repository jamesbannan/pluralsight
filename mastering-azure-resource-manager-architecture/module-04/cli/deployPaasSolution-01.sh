####################################################
#
# Script to deploy Carved Rock Fitness PaaS solution
#
####################################################

##############
### Demo 1 ###
##############

### Define Deployment Variables
appNamePrefix='crf'
locations=(
    "eastus"
    "westus"
)

### Create ARM Resource Groups
for i in "${locations[@]}"; do
    resourceGroupName="${appNamePrefix}-paas-${i}"
    az group create --name ${resourceGroupName} --location ${i} \
    --output table
done

### Create App Service Plans
for i in "${locations[@]}"; do
    resourceGroupName="${appNamePrefix}-paas-${i}"
    resourceGroup=$(az group show --name ${resourceGroupName} --output json)
    resourceGroupLocation=$(echo $resourceGroup | jq .location -r)

    appServicePlanName="${appNamePrefix}-plan-${resourceGroupLocation}"

    az appservice plan create \
        --resource-group $(echo $resourceGroup | jq .name -r) \
        --name ${appServicePlanName} \
        --location $(echo $resourceGroup | jq .location -r) \
        --sku S1 \
        --is-linux \
        --output table
done

### Create Web Apps
for i in "${locations[@]}"; do
    resourceGroupName="${appNamePrefix}-paas-${i}"
    resourceGroup=$(az group show --name ${resourceGroupName} --output json)
    resourceGroupLocation=$(echo $resourceGroup | jq .location -r)

    webAppName="${appNamePrefix}-web-${resourceGroupLocation}"
    appServicePlanName="${appNamePrefix}-plan-${resourceGroupLocation}"
    
    az webapp create \
        --resource-group $(echo $resourceGroup | jq .name -r) \
        --name ${webAppName} \
        --plan ${appServicePlanName} \
        --deployment-container-image-name nginx \
        --verbose
done
