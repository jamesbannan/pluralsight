############################################
#
# Script to manage Role Based Access Control
#
############################################

### Assign resource roles to Lab User
# Get user details
$userDetails = Get-AzADUser | Where-Object {$_.UserPrincipalName -like 'labuser01*'}
$userPrincipalName = $userDetails.UserPrincipalName

# Assign permissions at subscription level
$context = Get-AzContext
$subscriptionId = $context.Subscription.Id

New-AzRoleAssignment `
    -SignInName $userPrincipalName `
    -Scope "/subscriptions/$subscriptionId" `
    -RoleDefinitionName 'Reader'

# Assign permissions at Resource Group level
# Define Deployment Variables
$appNamePrefix = 'crf'
$resourceGroupName = "$appNamePrefix-rbac-demo"
$resourceGroupLocation = 'West US'

$resourceGroup = New-AzResourceGroup `
    -Name $resourceGroupName `
    -Location $resourceGroupLocation

New-AzRoleAssignment `
    -SignInName $userPrincipalName `
    -Scope $resourceGroup.ResourceId `
    -RoleDefinitionName 'Contributor'
