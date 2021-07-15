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

### Deploy VM NIC
location=$(echo $locationDetails | jq -c '.[] | select(.Region | match("Primary")) | .Location' -r)
resourceGroupName="${appNamePrefix}-iaas-${location}"

vmName="${appNamePrefix}admin${location}"
nicName="${appNamePrefix}admin${location}-nic"
vNetName="$appNamePrefix-vnet-$location"
subnetName='AdminSubnet'

az network nic create \
    --name ${nicName} \
    --resource-group ${resourceGroupName} \
    --location ${location} \
    --vnet-name ${vNetName} \
    --subnet ${subnetName}

### Deploy admin Virtual Machine
# Define Deployment Variables
location=$(echo $locationDetails | jq -c '.[] | select(.Region | match("Primary")) | .Location' -r)
resourceGroupName="${appNamePrefix}-iaas-${location}"

storageAccount=$(az storage account list --resource-group ${resourceGroupName})
storageAccountName=$(echo $storageAccount | jq '.[0].name' -r)

nic=$(az network nic list --resource-group ${resourceGroupName})
nicName=$(echo $nic | jq '.[0].name' -r)

vmName="${appNamePrefix}admin${location}"
osDiskName="${appNamePrefix}admin${location}-os"

vmImage='Win2019Datacenter'
vmSize='Standard_DS2_v2'
adminUser='crfadmin'
adminPassword='crfP@55admin123'

# Deploy VM
az vm create \
    --name ${vmName} \
    --resource-group ${resourceGroupName} \
    --location ${location} \
    --image ${vmImage} \
    --boot-diagnostics-storage ${storageAccountName} \
    --size ${vmSize} \
    --authentication password \
    --admin-username ${adminUser} \
    --admin-password ${adminPassword} \
    --nics ${nicName} \
    --os-disk-name ${osDiskName}

### Enable resource diagnostic settings
# Define Deployment Variables
resourceGroupName="${appNamePrefix}-iaas-${location}"

vm=$(az vm list --resource-group ${resourceGroupName})
vmName=$(echo $vm | jq '.[0].name' -r)
vmResourceId=$(echo $vm | jq '.[0].id' -r)

storageAccount=$(az storage account list --resource-group ${resourceGroupName})
storageAccountName=$(echo $storageAccount | jq '.[0].name' -r)

date=$(date -v+10y -u "+%Y-%m-%dT%H:%M:%SZ") # MacOS
date=$(date -d "+10 years" -u "+%Y-%m-%dT%H:%M:%SZ") # Linux

# Generate diagnostics configuration
diagnosticsConfig=$(az vm diagnostics get-default-config --is-windows-os \
    | sed "s#__DIAGNOSTIC_STORAGE_ACCOUNT__#${storageAccountName}#g" \
    | sed "s#__VM_OR_VMSS_RESOURCE_ID__#${vmResourceId}#g")

# Generate SAS token
sasToken=$(az storage account generate-sas \
    --account-name ${storageAccountName} \
    --expiry ${date} \
    --permissions acuw \
    --resource-types co \
    --services bt \
    --https-only \
    --output tsv)

protectedSettings="{'storageAccountName': '${storageAccountName}', 'storageAccountSasToken': '${sasToken}'}"

az vm diagnostics set \
    --resource-group ${resourceGroupName} \
    --settings ${diagnosticsConfig} \
    --protected-settings ${protectedSettings} \
    --vm-name ${vmName}