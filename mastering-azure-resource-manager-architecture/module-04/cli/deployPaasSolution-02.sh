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

### Enable App Service Logs
for i in "${locations[@]}"; do
    # Define Deployment Variables
    resourceGroupName="${appNamePrefix}-paas-${i}"
    resourceGroup=$(az group show --name ${resourceGroupName} --output json)
    resourceGroupLocation=$(echo $resourceGroup | jq .location -r)
    resourceGroupId=$(echo $resourceGroup | jq .id -r | shasum)
    nameSuffix="${resourceGroupId:0:4}" 

    webAppName="${appNamePrefix}-web-${resourceGroupLocation}-${nameSuffix}"

    # Configure App Service Logs
    az webapp log config \
        --resource-group ${resourceGroupName} \
        --name ${webAppName} \
        --docker-container-logging filesystem
done

### Configure Diagnostic Settings
for i in "${locations[@]}"; do
    # Define Deployment Variables
    resourceGroupName="${appNamePrefix}-paas-${i}"
    resourceGroup=$(az group show --name ${resourceGroupName} --output json)
    resourceGroupLocation=$(echo $resourceGroup | jq .location -r)
    resourceGroupId=$(echo $resourceGroup | jq .id -r | shasum)
    nameSuffix="${resourceGroupId:0:4}" 

    webAppName="${appNamePrefix}-web-${resourceGroupLocation}-${nameSuffix}"
    webAppId=$(az webapp show --resource-group ${resourceGroupName} --name ${webAppName} --query id --output tsv)
    storageAccountName="${appNamePrefix}weblogs${resourceGroupLocation}${nameSuffix}"

    # Deploy Storage Account for Logs
    storageAccount=$(az storage account create \
        --resource-group ${resourceGroupName} \
        --location ${resourceGroupLocation} \
        --name ${storageAccountName} \
        --kind StorageV2 \
        --sku Standard_LRS \
        --output json)

    # Configure Diagnostic Settings on Web App
    az monitor diagnostic-settings create \
        --name WebAppDiagnostics \
        --resource ${webAppId} \
        --logs '[{"category": "AppServiceHTTPLogs","enabled": true},{"category": "AppServiceAppLogs","enabled": true},{"category": "AppServicePlatformLogs","enabled": true}]' \
        --metrics '[{"category": "AllMetrics","enabled": true}]' \
        --storage-account $(echo $storageAccount | jq .id -r)
done

### Enable Application Insights
for i in "${locations[@]}"; do
    # Define Deployment Variables
    resourceGroupName="${appNamePrefix}-paas-${i}"
    resourceGroup=$(az group show --name ${resourceGroupName} --output json)
    resourceGroupLocation=$(echo $resourceGroup | jq .location -r)
    resourceGroupId=$(echo $resourceGroup | jq .id -r | shasum)
    nameSuffix="${resourceGroupId:0:4}" 

    webAppName="${appNamePrefix}-web-${resourceGroupLocation}-${nameSuffix}"
    webAppId=$(az webapp show --resource-group ${resourceGroupName} --name ${webAppName} --query id --output tsv)

    appInsightsName="$appNamePrefix-ai-$resourceGroupLocation-$nameSuffix"
    
    # Create Application Insights Component
    az monitor app-insights component create \
        --resource-group $resourceGroupName \
        --location $resourceGroupLocation \
        --app $appInsightsName

    # Get Instrumentation Key
    instrumentationKey=$(az monitor app-insights component show \
        --resource-group $resourceGroupName \
        --app $appInsightsName \
        --query "instrumentationKey" \
        --output tsv)

    # Enable Application Insights in Web App
    az webapp config appsettings set \
        --resource-group $resourceGroupName \
        --name $webAppName \
        --settings "APPINSIGHTS_INSTRUMENTATIONKEY=$instrumentationKey"

    az webapp config appsettings set \
        --resource-group $resourceGroupName \
        --name $webAppName \
        --settings "ApplicationInsightsAgent_EXTENSION_VERSION=~2"

    az webapp config appsettings set \
        --resource-group $resourceGroupName \
        --name $webAppName \
        --settings "XDT_MicrosoftApplicationInsights_Mode=recommended"
done
