
### Define variables
{

$location = 'Australia Southeast'
$resourceGroupName = 'contoso-keyvault'
$resourceDeploymentName = 'contoso-vault'
$keyVaultName = 'contoso-vault'
$password = 'C0nt0s0P@55'
$secretName = 'vmAdminPassword'

}

### Create Resource Group
{

New-AzureRmResourceGroup `
    -Name $resourceGroupName `
    -Location $location `
    -Verbose -Force

}

### Create Key Vault
{

New-AzureRmKeyVault `
    -VaultName $keyVaultName `
    -ResourceGroupName $resourceGroupName `
    -Location $location `
    -EnabledForTemplateDeployment

}

### Add Password to Key Vault
{

$adminPass = ConvertTo-SecureString `
    -String $password `
    -AsPlainText -Force

Set-AzureKeyVaultSecret `
    -VaultName $keyVaultName `
    -Name $secretName `
    -SecretValue $adminPass

}

### Get Subscription ID
{

(Get-AzureRmSubscription).Id

}