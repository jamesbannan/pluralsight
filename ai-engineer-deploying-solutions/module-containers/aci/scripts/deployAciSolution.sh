# Get Remote State Storage Account details
tfstateRg='ps-aci-tfstate'
tfstateAccount=$(az storage account list --resource-group ${tfstateRg} | jq '[.[]][0]')
tfstateAccountName=$(echo $tfstateAccount | jq .name -r)
tfstateAccountKey=$(az storage account keys list --resource-group ${tfstateRg} --account-name ${tfstateAccountName} | jq '[.[]][0].value' -r)
tfstateContainer='tfstate'
tfstateKeyName='key=pluralsight-aci.tfstate'

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
planName='aci-hello-world.plan'
terraform plan -out=${planName}

# Deploy solution
terraform apply -auto-approve ${planName}
