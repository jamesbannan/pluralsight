####################################################
#
# Script to deploy Carved Rock Fitness PaaS solution
#
####################################################

##############
### Demo 2 ###
##############

### Define Deployment Variables
appNamePrefix='crf'
locations=(
    "eastus"
    "westus"
)

### Create Container Registries
for i in "${locations[@]}"; do
    resourceGroupName="${appNamePrefix}-paas-${i}"
    resourceGroup=$(az group show --name ${resourceGroupName} --output json)
    resourceGroupLocation=$(echo $resourceGroup | jq .location -r)
    resourceGroupId=$(echo $resourceGroup | jq .id -r | shasum)
    nameSuffix="${resourceGroupId:0:4}" 

    acrName="${appNamePrefix}acr${resourceGroupLocation}${nameSuffix}"

    az acr create \
        --resource-group $(echo $resourceGroup | jq .name -r) \
        --name ${acrName} \
        --sku standard \
        --location $(echo $resourceGroup | jq .location -r) \
        --output table
done

### Push Image to Container Registries
for i in "${locations[@]}"; do
    resourceGroupName="${appNamePrefix}-paas-${i}"
    resourceGroup=$(az group show --name ${resourceGroupName} --output json)
    resourceGroupLocation=$(echo $resourceGroup | jq .location -r)
    resourceGroupId=$(echo $resourceGroup | jq .id -r | shasum)
    nameSuffix="${resourceGroupId:0:4}" 

    acrName="${appNamePrefix}acr${resourceGroupLocation}${nameSuffix}"
    acr=$(az acr show --name ${acrName} --resource-group ${resourceGroupName} --output json)

    az acr login --name ${acrName} --output tsv
    docker tag carvedrockweb:latest "${acrName}.azurecr.io/carvedrockweb:latest"
    docker push "${acrName}.azurecr.io/carvedrockweb:latest"
done
