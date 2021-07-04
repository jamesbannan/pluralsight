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
