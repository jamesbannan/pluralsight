#######################################
#
# Script to deploy simple IaaS solution
#
#######################################

### Authenticate to Azure
az login

### Define Deployment Variables
appNamePrefix='crf'
resourceGroupName="${appNamePrefix}-simple-iaas"
resourceGroupLocation='eastus'

resourceProviderNamespace='Microsoft.Network'
resourceTypeName='virtualNetworks'

vNetName="vnet-${appNamePrefix}"
vNetAddressPrefix='172.16.0.0/16'
vNetSubnet1Name='subnet-1'
vNetSubnet1Prefix='172.16.1.0/24'
vNetSubnet2Name='subnet-2'
vNetSubnet2Prefix='172.16.2.0/24'

storageAccountNamePrefix='storage'

### Get ARM Provider Locations
query="resourceTypes[*].{Name:resourceType, Locations:locations}[?Name=='${resourceTypeName}']"
az provider show --namespace ${resourceProviderNamespace} --query ${query}

### Create ARM Resource Group
resourceGroup=$(az group create \
    --name ${resourceGroupName} \
    --location ${resourceGroupLocation} \
    --verbose)

### Create Virtual Network
az network vnet create \
    --resource-group ${resourceGroupName} \
    --name ${vNetName} \
    --location ${resourceGroupLocation} \
    --address-prefixes ${vNetAddressPrefix} \
    --verbose

### Create Virtual Network Subnets
az network vnet subnet create \
    --resource-group ${resourceGroupName} \
    --name ${vNetSubnet1Name} \
    --vnet-name ${vNetName} \
    --address-prefixes ${vNetSubnet1Prefix} \
    --verbose

az network vnet subnet create \
    --resource-group ${resourceGroupName} \
    --name ${vNetSubnet2Name} \
    --vnet-name ${vNetName} \
    --address-prefixes ${vNetSubnet2Prefix} \
    --verbose

### Create Storage Account
resourceGroupId=$(echo $resourceGroup | jq .id -r | shasum)
nameSuffix="${resourceGroupId:0:10}"
storageAccountName="${storageAccountNamePrefix}${nameSuffix}"

az storage account create \
    --resource-group ${resourceGroupName} \
    --name ${storageAccountName} \
    --location ${resourceGroupLocation} \
    --kind StorageV2 \
    --sku Standard_LRS \
    --verbose
