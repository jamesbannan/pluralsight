# Create Resource Group for Terraform Remote State
groupName='demo-tfstate'
groupLocation='Australia East'
group=$(az group create --name ${groupName} --location "${groupLocation}" --verbose)

# Create Storage Account for Terraform Remote State
accountName=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 12 | head -n 1)
storage=$(az storage account create \
    --name ${accountName} \
    --resource-group $(echo $group | jq .name -r) \
    --location $(echo $group | jq .location -r) \
    --sku Standard_LRS \
    )

# Create container for Terraform Remote State
containerName='tfstate'
az storage container create \
    --name ${containerName} \
    --account-name $(echo $storage | jq .name -r) \
    --account-key $(az storage account keys list --resource-group $(echo $group | jq .name -r) --account-name $(echo $storage | jq .name -r) | jq .[0].value -r)
