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

### Deploy Virtual Machine Scale Set
location=$(echo $locationDetails | jq -c '.[] | select(.Region | match("Secondary")) | .Location' -r)
resourceGroupName="${appNamePrefix}-iaas-${location}"

az vmss create \
    --name ${vmssName} \
    --resource-group ${resourceGroupName} \
    --location ${location} \
    --custom-data '../cloud-init.yml'