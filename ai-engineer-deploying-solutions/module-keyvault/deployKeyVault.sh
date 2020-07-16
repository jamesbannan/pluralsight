### Create Resource Group
groupName='ps-security'
groupLocation='Australia East'
group=$(az group create --name ${groupName} --location "${groupLocation}" --verbose)
groupId=$(echo $group | jq .id -r | shasum)

### Deploy Azure Key Vault
vaultSuffix="${groupId:0:10}"
vaultName="ps-vault-${accountSuffix}"
vault=$(az keyvault create \
    --name ${vaultName} \
    --resource-group $(echo $group | jq .name -r) \
    --location $(echo $group | jq .location -r) \
    --sku standard \
    --enabled-for-deployment true \
    --enabled-for-disk-encryption true \
    --enabled-for-template-deployment true \
    )