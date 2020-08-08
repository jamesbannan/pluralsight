### Get Resource Group
groupName='ps-security'
group=$(az group show --name ${groupName})
groupId=$(echo $group | jq .id -r | shasum)

### Deploy Storage Account
accountSuffix="${groupId:0:10}"
accountName="ps${accountSuffix}"
storage=$(az storage account create \
    --name ${accountName} \
    --resource-group $(echo $group | jq .name -r) \
    --location $(echo $group | jq .location -r) \
    --sku Standard_LRS \
    )

### Assign role to Storage Account
vaultSp=$(az ad sp show --id "cfa8b339-82a2-471a-a3c9-0fc0be7a4093")
az role assignment create \
    --role "Storage Account Key Operator Service Role" \
    --assignee-object-id $(echo $vaultSp | jq .objectId -r) \
    --scope $(echo $storage | jq .id -r)
