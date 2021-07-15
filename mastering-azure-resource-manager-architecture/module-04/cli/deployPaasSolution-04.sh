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

### Assign a user identity to Web Apps
for i in "${locations[@]}"; do
    # Define Deployment Variables
    resourceGroupName="${appNamePrefix}-paas-${i}"
    resourceGroup=$(az group show --name ${resourceGroupName} --output json)
    resourceGroupLocation=$(echo $resourceGroup | jq .location -r)
    resourceGroupId=$(echo $resourceGroup | jq .id -r | shasum)
    nameSuffix="${resourceGroupId:0:4}" 

    webAppName="${appNamePrefix}-web-${resourceGroupLocation}-${nameSuffix}"
    identityName="${webAppName}-identity"

    # Create User-Assigned Identity
    az identity create \
        --name $identityName \
        --resource-group ${resourceGroupName} \
        --location ${resourceGroupLocation} \
        --output none

    identityId=$(az identity show --resource-group ${resourceGroupName} --name ${identityName} --query id --output tsv)
    identityClientId=$(az identity show --resource-group ${resourceGroupName} --name ${identityName} --query clientId --output tsv)
    
    # Assign Identity to Web App
    az webapp identity assign \
        --resource-group $(echo $resourceGroup | jq .name -r) \
        --name ${webAppName} \
        --identities ${identityId} \
        --output none

    webConfig=$(az webapp show --resource-group ${resourceGroupName} --name ${webAppName} --query id --output tsv)"/config/web"

    az resource update \
        --ids ${webConfig} \
        --set properties.acrUseManagedIdentityCreds=True \
        --output none

    az resource update \
        --ids ${webConfig} \
        --set properties.AcrUserManagedIdentityID=${identityClientId} \
        --output none
done

### Grant ACR access to the Web App identity
for i in "${locations[@]}"; do
    # Define Deployment Variables
    resourceGroupName="${appNamePrefix}-paas-${i}"
    resourceGroup=$(az group show --name ${resourceGroupName} --output json)
    resourceGroupLocation=$(echo $resourceGroup | jq .location -r)
    resourceGroupId=$(echo $resourceGroup | jq .id -r | shasum)
    nameSuffix="${resourceGroupId:0:4}" 

    acrName="${appNamePrefix}acr${resourceGroupLocation}${nameSuffix}"
    webAppName="${appNamePrefix}-web-${resourceGroupLocation}-${nameSuffix}"
    identityName="${webAppName}-identity"

    # Retrieve Identity Details
    acrId=$(az acr show \
        --resource-group $(echo $resourceGroup | jq .name -r) \
        --name ${acrName} \
        --query id \
        --output tsv)

    identityPrincpalId=$(az identity show \
        --resource-group ${resourceGroupName} \
        --name ${identityName} \
        --query principalId \
        --output tsv)

    # Assign RBAC on ACR
    az role assignment create \
        --assignee ${identityPrincpalId} \
        --scope ${acrId} \
        --role acrpull \
        --output json
done
