####################################################
#
# Script to deploy Carved Rock Fitness IaaS solution
#
####################################################

##############
### Demo 1 ###
##############

### Define Deployment Variables
appNamePrefix='crf'
locationDetails=$(cat ../../module-05/locationDetails.json)

### Deploy Public IP Address
location=$(echo $locationDetails | jq -c '.[] | select(.Region | match("Primary")) | .Location' -r)
resourceGroupName="${appNamePrefix}-iaas-${location}"

pipName="$appNamePrefix-pip-bastion-$location"

az network public-ip create \
    --name ${pipName} \
    --resource-group ${resourceGroupName} \
    --location ${location} \
    --allocation-method Static \
    --sku Standard

### Deploy Azure Bastion
location=$(echo $locationDetails | jq -c '.[] | select(.Region | match("Primary")) | .Location' -r)
resourceGroupName="${appNamePrefix}-iaas-${location}"

vNet=$(az network vnet list --resource-group ${resourceGroupName})
vNetName=$(echo $vNet | jq '.[0].name' -r)

pip=$(az network public-ip list --resource-group ${resourceGroupName})
pipName=$(echo $pip | jq '.[0].name' -r)

bastionName="${appNamePrefix}-bastion-${location}"

az network bastion create \
    --name ${bastionName} \
    --resource-group ${resourceGroupName} \
    --location ${location} \
    --vnet-name ${vNetName} \
    --public-ip-address ${pipName}

### Enable resource diagnostic settings
# Define Deployment Variables
resourceGroupName="${appNamePrefix}-iaas-${location}"

# Enable diagnostics on IP Address
pip=$(az network public-ip list --resource-group ${resourceGroupName})
pipResourceId=$(echo $pip | jq '.[0].id' -r)

storageAccount=$(az storage account list --resource-group ${resourceGroupName})
storageAccountResourceId=$(echo $storageAccount | jq '.[0].id' -r)

logs='[
    {
        "category": "DDosProtectionNotifications",
        "enabled": true,
        "retentionPolicy": {
                "enabled": true,
                "days": 90
            }
    }
]'
metrics='[
    {
        "category": "AllMetrics",
        "enabled": true,
        "retentionPolicy": {
            "enabled": true,
            "days": 90
        }
    }
]'

az monitor diagnostic-settings create \
    --name 'pipDiagnostics' \
    --resource-group ${resourceGroupName} \
    --resource ${pipResourceId} \
    --storage-account ${storageAccountResourceId} \
    --logs ${logs} \
    --metrics ${metrics}

# Enable diagnostics on Bastion
bastion=$(az network bastion list --resource-group ${resourceGroupName})
bastionResourceId=$(echo $bastion | jq '.[0].id' -r)

storageAccount=$(az storage account list --resource-group ${resourceGroupName})
storageAccountResourceId=$(echo $storageAccount | jq '.[0].id' -r)

logs='[
    {
        "category": "BastionAuditLogs",
        "enabled": true,
        "retentionPolicy": {
                "enabled": true,
                "days": 90
            }
    }
]'
metrics='[
    {
        "category": "AllMetrics",
        "enabled": true,
        "retentionPolicy": {
            "enabled": true,
            "days": 90
        }
    }
]'

az monitor diagnostic-settings create \
    --name 'bastionDiagnostics' \
    --resource-group ${resourceGroupName} \
    --resource ${bastionResourceId} \
    --storage-account ${storageAccountResourceId} \
    --logs ${logs} \
    --metrics ${metrics}
