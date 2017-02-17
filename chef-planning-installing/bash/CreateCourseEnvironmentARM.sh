#!/bin/bash

# https://azure.microsoft.com/en-us/documentation/articles/xplat-cli-azure-resource-manager/

# Define script variables
azureLocation="westus"
azureDeploymentName="chef-lab-deployment"
azureResourceGroupName="chef-lab"

# Setting the Azure Resource Manager mode
azure config mode arm

# Create Resource Group in Azure
azure group create \
  --name $azureResourceGroupName \
  --location $azureLocation -v

azure group deployment create \
--name $azureDeploymentName \
--resource-group $azureResourceGroupName \
--template-file azuredeploy.json \
--parameters-file azuredeploy.parameters.json -v

# azure group deployment show $azureResourceGroupName $azureDeploymentName
