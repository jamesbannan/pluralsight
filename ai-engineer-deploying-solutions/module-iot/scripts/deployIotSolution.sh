### Check Azure CLI extension
az extension list
extensions=( azure-cli-iot-ext )

for i in "${extensions[@]}"
do
	az extension add --name ${i} --verbose
done

# Get Remote State Storage Account details
tfstateRg='iot-tfstate'
tfstateAccount=$(az storage account list --resource-group ${tfstateRg} | jq '[.[]][0]')
tfstateAccountName=$(echo $tfstateAccount | jq .name -r)
tfstateAccountKey=$(az storage account keys list --resource-group ${tfstateRg} --account-name ${tfstateAccountName} | jq '[.[]][0].value' -r)
tfstateContainer='tfstate'
tfstateKeyName='key=pluralsight-iot.tfstate'

### Accept Marketplace terms for VM image
az vm image terms accept --plan 'ubuntu_1604_edgeruntimeonly' --publisher 'microsoft_iot_edge' --offer 'iot_edge_vm_ubuntu' 

### Deploy IoT Solution
# Initialise solution
terraform init \
    -backend-config="storage_account_name=${tfstateAccountName}" \
    -backend-config="container_name=${tfstateContainer}" \
    -backend-config="access_key=${tfstateAccountKey}" \
    -backend-config="${tfstateKeyName}"

# Validate solution
terraform validate

# Plan solution deployment
planName='iot-vision.plan'
terraform plan -out=${planName}

# Deploy solution
terraform apply -auto-approve ${planName}
