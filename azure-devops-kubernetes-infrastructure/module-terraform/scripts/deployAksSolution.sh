# Get Remote State Storage Account details
tfstateRg='demo-tfstate'
tfstateAccount=$(az storage account list --resource-group ${tfstateRg} | jq .[0])
tfstateAccountName=$(echo $tfstateAccount | jq .name -r)
tfstateAccountKey=$(az storage account keys list --resource-group ${tfstateRg} --account-name ${tfstateAccountName} | jq .[0].value -r)
tfstateContainer='tfstate'
tfstateKeyName='key=pluralsight-aks.tfstate'

# Generate SSH keys (This will overwrite any existing key called 'id_rsa')
yes y | ssh-keygen -t rsa -b 2048 -N "" -f ~/.ssh/id_rsa

### Deploy AKS Solution
# Initialise solution
terraform init \
    -backend-config="storage_account_name=${tfstateAccountName}" \
    -backend-config="container_name=${tfstateContainer}" \
    -backend-config="access_key=${tfstateAccountKey}" \
    -backend-config="${tfstateKeyName}"

# Validate solution
terraform validate

# Plan solution deployment
planName='aks-cluster.plan'
terraform plan -out=${planName}

# Deploy solution
terraform apply -auto-approve ${planName}

# Get kube-config
kubeConfigName='config'
echo "$(terraform output kube_config)" > $HOME/.kube/${kubeConfigName}
