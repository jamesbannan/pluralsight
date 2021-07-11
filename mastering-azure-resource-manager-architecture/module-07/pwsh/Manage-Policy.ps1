###############################
#
# Script to manage Azure Policy
#
###############################

### Assign Azure Policy
# Get Azure Policy
$policyDescription = 'Allowed locations for resource groups'
$policy = Get-AzPolicyDefinition | Where-Object {$_.Properties.DisplayName -eq "$policyDescription"}

# Assign Policy at subscription level
$context = Get-AzContext
$subscriptionId = $context.Subscription.Id

$policyAssignmentName = 'ResourceGroupAllowedRegions'

$allowedLocations = @{'listOfAllowedLocations'=('eastus','westus')}

New-AzPolicyAssignment `
    -Name $policyAssignmentName `
    -PolicyDefinition $policy `
    -Scope "/subscriptions/$subscriptionId" `
    -PolicyParameterObject $allowedLocations

# Deploy Resource Group
$appNamePrefix = 'crf'
$resourceGroupName = "$appNamePrefix-rbac-demo-03"
$resourceGroupLocation = 'Southeast Asia'

New-AzResourceGroup `
    -Name $resourceGroupName `
    -Location $resourceGroupLocation
