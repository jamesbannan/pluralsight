####################################################
#
# Script to deploy Carved Rock Fitness PaaS solution
#
####################################################

##############
### Demo 5 ###
##############

### Define Deployment Variables
appNamePrefix='crf'
locations=(
    "eastus"
    "westus"
)

### Configure WebApp to pull image:tag from ACR
for i in "${locations[@]}"; do
    # Define Deployment Variables
    resourceGroupName="${appNamePrefix}-paas-${i}"
    resourceGroup=$(az group show --name ${resourceGroupName} --output json)
    resourceGroupLocation=$(echo $resourceGroup | jq .location -r)
    resourceGroupId=$(echo $resourceGroup | jq .id -r | shasum)
    nameSuffix="${resourceGroupId:0:4}" 

    acrName="${appNamePrefix}acr${resourceGroupLocation}${nameSuffix}"
    webAppName="${appNamePrefix}-web-${resourceGroupLocation}-${nameSuffix}"

    # Retrieve ACR Details
    acrUri=$(az acr show \
        --resource-group $(echo $resourceGroup | jq .name -r) \
        --name ${acrName} \
        --query loginServer \
        --output tsv)

    image="carvedrockweb:latest"
    fxVersion="Docker|"${acrUri}"/"${image}

    webConfig=$(az webapp show --resource-group ${resourceGroupName} --name ${webAppName} --query id --output tsv)"/config/web"

    # Update Web App to pull custom Docker image
    az resource update \
        --ids $webConfig \
        --set properties.linuxFxVersion=$fxVersion \
        --output json \
        --force-string
    
    az webapp restart --resource-group ${resourceGroupName} --name ${webAppName}
done
