#!/bin/bash
set +x

### REQUIRES jq to be installed...
# sudo apt-get install jq	
# sudo yum --enablerepo=epel install jq

# presets
deploymentName="chef-lab"
providedGroupName="chef-lab"
publicDNSName="chef-lab-$(date +%s)"
adminUserName="chef"

#get required values from azure cli
export gName=`azure group list --json | jq -r '.[] .name'`
export vNet=`azure network vnet list --json | jq -r '.[] .name'`
export sAName=`azure storage account list --json | jq -r '.[] .name'`

# just to show our values
echo "resource group name: $gName"
echo "virtual network name: $vNet"
echo "storage account name: $sAName"
echo "provided Group Name: $providedGroupName"
echo "public DNS Name: $publicDNSName"
echo "admin User Name: $adminUserName"

# copy params to side.. replacing our changes
cat parameters.json | sed "s/SANPARAM/$sAName/g" | sed "s/AUNPARAM/$adminUserName/g" | sed "s/DNSFPIPARAM/$publicDNSName/g" | sed "s/VNNPARAM/$vNet/g" > parameters-new.json

# this just tells bash to print out the command first.. saves an echo
set -x
# optional: add --debug-setting all
azure group deployment create --verbose --name $deploymentName --resource-group $gName --template-file "WindowsClient.json" --parameters-file "parameters-new.json"

# checking after...
azure group deployment list $deploymentName
azure vm list $deploymentName

exit

