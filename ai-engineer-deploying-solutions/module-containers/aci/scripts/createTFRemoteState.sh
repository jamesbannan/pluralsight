# Create Resource Group for Terraform Remote State
groupName='ps-aci-tfstate'
groupLocation='Australia East'
group=$(az group create --name ${groupName} --location "${groupLocation}" --verbose)
groupId=$(echo $group | jq .id -r | shasum)

# Create Storage Account for Terraform Remote State
accountSuffix="${groupId:0:10}"
accountName="aci${accountSuffix}"
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
    --account-key $(az storage account keys list \
        --resource-group $(echo $group | jq .name -r) \
        --account-name $(echo $storage | jq .name -r) | jq '[.[]][0].value' -r)
