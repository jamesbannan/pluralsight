####################################################
#
# Script to deploy Carved Rock Fitness PaaS solution
#
####################################################

##############
### Demo 4 ###
##############

### Define Deployment Variables
appNamePrefix='crf'
locations=(
    "eastus"
    "westus"
)

### Configure WebApp to pull image:tag from ACR
for i in "${locations[@]}"; do
    resourceGroupName="${appNamePrefix}-paas-${i}"
    resourceGroup=$(az group show --name ${resourceGroupName} --output json)

    acrName="${appNamePrefix}-acr-${resourceGroupLocation}"
    webAppName="${appNamePrefix}-web-${resourceGroupLocation}"

    acrUri=$(az acr show \
        --resource-group $(echo $resourceGroup | jq .name -r) \
        --name ${acrName} \
        --query loginServer \
        --output tsv)

    image="myapp:latest"
    fxVersion="Docker|"${acrUri}"/"${image}

    identityId=$(az webapp identity show \
        --resource-group $(echo $resourceGroup | jq .name -r) \
        --name ${webAppName} \
        --output tsv)

    config=$(az webapp show \
        --resource-group $(echo $resourceGroup | jq .name -r) \
        --name ${webAppName} \ 
        --query id 
        --output tsv) + "/config/web"

    az resource update \
        --ids $config \
        --set properties.linuxFxVersion=$fxVersion \
        --output none \
        --force-string
done
