###################################
#
# Script to manage custom RBAC role
#
###################################

### Assign resource roles to Lab User
# Get user details
$userDetails = Get-AzADUser `
 | Where-Object {$_.UserPrincipalName -like 'labuser01*'}
$userPrincipalName = $userDetails.UserPrincipalName

# Deploy new custom role
$roleDefinition = "../readerSupport.json"
$role = New-AzRoleDefinition -InputFile $roleDefinition

# Assign permissions at Resource Group level
# Define Deployment Variables
$appNamePrefix = 'crf'
$resourceGroupName = "$appNamePrefix-rbac-demo-02"
$resourceGroupLocation = 'West US'
$roleName = $role.Name

$resourceGroup = New-AzResourceGroup `
    -Name $resourceGroupName `
    -Location $resourceGroupLocation

New-AzRoleAssignment `
    -SignInName $userPrincipalName `
    -Scope $resourceGroup.ResourceId `
    -RoleDefinitionName $roleName
