####################################################
#
# Script to deploy Carved Rock Fitness PaaS solution
#
####################################################

##############
### Demo 3 ###
##############

### Define Deployment Variables
appNamePrefix='crf'
locations=(
    "eastus"
    "westus"
)

### Assign a managed service identity to Web Apps
for i in "${locations[@]}"; do
    resourceGroupName="${appNamePrefix}-paas-${i}"
    resourceGroup=$(az group show --name ${resourceGroupName} --output json)

    webAppName="${appNamePrefix}-web-${resourceGroupLocation}"
    
    az webapp identity assign \
        --resource-group $(echo $resourceGroup | jq .name -r) \
        --name ${webAppName} \
        --query principalId \
        --output tsv

    config=$(az webapp show \
        --resource-group $(echo $resourceGroup | jq .name -r) \
        --name ${webAppName} \ 
        --query id 
        --output tsv) + "/config/web"
done

### Use Web Apps MSI for Docker pull operations
for i in "${locations[@]}"; do
    resourceGroupName="${appNamePrefix}-paas-${i}"
    resourceGroup=$(az group show --name ${resourceGroupName} --output json)

    webAppName="${appNamePrefix}-web-${resourceGroupLocation}"

    config=$(az webapp show \
        --resource-group $(echo $resourceGroup | jq .name -r) \
        --name ${webAppName} \ 
        --query id 
        --output tsv) + "/config/web"

    az resource update \
        --ids ${config} \
        --set properties.acrUseManagedIdentityCreds=True \
        --output none
done

### Grant ACR access to the Web App identity
for i in "${locations[@]}"; do
    resourceGroupName="${appNamePrefix}-paas-${i}"
    resourceGroup=$(az group show --name ${resourceGroupName} --output json)

    acrName="${appNamePrefix}-acr-${resourceGroupLocation}"
    webAppName="${appNamePrefix}-web-${resourceGroupLocation}"

    acrId=$(az acr show \
        --resource-group $(echo $resourceGroup | jq .name -r) \
        --name ${acrName} \
        --query id \
        --output tsv)

    identityId=$(az webapp identity assign \
        --resource-group $(echo $resourceGroup | jq .name -r) \
        --name ${webAppName} \
        --query principalId \
        --output tsv)

    az role assignment create \
        --assignee ${identityId} \
        --scope ${acrId} \
        --role acrpull \
        --output tsv
done

# Step 3: Configure WebApp to pull image:tag from ACR
# Modify for your environment
ACR_URL=$(az acr show -g $RG_Name --n $ACR_Name --query loginServer --output tsv)
Image="myapp:latest"
FX_Version="Docker|"$ACR_URL"/"$Image

#Configure the ACR, Image and Tag to pull
az resource update --ids $Webapp_Config --set properties.linuxFxVersion=$FX_Version -o none --force-string
