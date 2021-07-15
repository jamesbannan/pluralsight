####################################################
#
# Script to deploy Carved Rock Fitness IaaS solution
#
####################################################

##############
### Demo 3 ###
##############

### Define Deployment Variables
appNamePrefix='crf'
locationDetails=$(cat ../../module-05/locationDetails.json)

### Deploy VM Scale Set Load Balancer
# Define Deployment Variables
location=$(echo $locationDetails | jq -c '.[] | select(.Region | match("Secondary")) | .Location' -r)
resourceGroupName="${appNamePrefix}-iaas-${location}"

vNetName="$appNamePrefix-vnet-$location"
subnetName='AppSubnet'
lbName="$appNamePrefix-app-lb-$location"

# Deploy internal Load Balancer
az network lb create \
    --name ${lbName} \
    --resource-group ${resourceGroupName} \
    --location ${location} \
    --sku Basic \
    --vnet-name ${vNetName} \
    --subnet ${subnetName} \
    --frontend-ip-name PrivateFrontEnd \
    --backend-pool-name AppVmScaleSet

# Provision Health Probe
healthProbeName='crf-app-probe-tcp-80'

az network lb probe create \
    --resource-group ${resourceGroupName} \
    --lb-name ${lbName} \
    --name ${healthProbeName} \
    --protocol tcp \
    --port 80

# Provision load balancer Rule
ruleName='crf-app-lb-tcp-80'

az network lb rule create \
    --resource-group ${resourceGroupName} \
    --lb-name ${lbName} \
    --name ${ruleName} \
    --protocol tcp \
    --frontend-port 80 \
    --backend-port 80 \
    --frontend-ip-name PrivateFrontEnd \
    --backend-pool-name AppVmScaleSet \
    --probe-name ${healthProbeName} \
    --idle-timeout 15

### Deploy Virtual Machine Scale Set
location=$(echo $locationDetails | jq -c '.[] | select(.Region | match("Secondary")) | .Location' -r)
resourceGroupName="${appNamePrefix}-iaas-${location}"
vmssName="$appNamePrefix-app-vmss-$location"

vNetName="$appNamePrefix-vnet-$location"
subnetName='AppSubnet'

lb=$(az network lb list --resource-group ${resourceGroupName})
lbName=$(echo $lb | jq '.[0].name' -r)

vmImage='UbuntuLTS'
vmSize='Standard_DS1_v2'
adminUser='crfadmin'
adminPassword='crfP@55admin123'

az vmss create \
    --name ${vmssName} \
    --resource-group ${resourceGroupName} \
    --location ${location} \
    --custom-data '../cloud-init.yml' \
    --image ${vmImage} \
    --instance-count 2 \
    --vm-sku ${vmSize} \
    --authentication-type password \
    --admin-username ${adminUser} \
    --admin-password ${adminPassword} \
    --vnet-name ${vNetName} \
    --subnet ${subnetName} \
    --load-balancer ${lbName}

### Enable resource diagnostic settings
# Define Deployment Variables
resourceGroupName="${appNamePrefix}-iaas-${location}"

# Enable diagnostics on VM Scale Set
vmss=$(az vmss list --resource-group ${resourceGroupName})
vmssName=$(echo $vmss | jq '.[0].name' -r)
vmssResourceId=$(echo $vmss | jq '.[0].id' -r)

storageAccount=$(az storage account list --resource-group ${resourceGroupName})
storageAccountResourceId=$(echo $storageAccount | jq '.[0].id' -r)
storageAccountBlobUrl=$(echo $storageAccount | jq '.[0].primaryEndpoints.blob' -r)

date=$(date -v+10y -u "+%Y-%m-%dT%H:%M:%SZ") # MacOS
date=$(date -d "+10 years" -u "+%Y-%m-%dT%H:%M:%SZ") # Linux

# Generate diagnostics configuration
diagnosticsConfig=$(az vmss diagnostics get-default-config \
    | sed "s#__DIAGNOSTIC_STORAGE_ACCOUNT__#${storageAccountName}#g" \
    | sed "s#__VM_OR_VMSS_RESOURCE_ID__#${vmssResourceId}#g")

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

az vmss diagnostics set \
    --resource-group ${resourceGroupName} \
    --settings ${diagnosticsConfig} \
    --protected-settings ${protectedSettings} \
    --vmss-name ${vmssName}

# Enable boot diagnostics on VM Scale Set
az vmss update \
    --name ${vmssName} \
    --resource-group ${resourceGroupName} \
    --set virtualMachineProfile.diagnosticsProfile="{\"bootDiagnostics\": {\"Enabled\" : \"True\",\"StorageUri\":\"${storageAccountBlobUrl}\"}}"

# Update VM Scale Set instances
az vmss update-instances \
    --instance-ids "*" \
    --name ${vmssName} \
    --resource-group ${resourceGroupName}
