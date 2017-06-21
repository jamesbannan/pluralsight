
### Create and Apply Location Policy
{

$policyName = 'policyLocationDefinition'
$policyAssignment = 'policyLocationAssignment'
$policyFile = $env:SystemDrive + '\' + 'pluralsight' + '\' + 'policylocation.json'

New-AzureRmPolicyDefinition `
    -Name $policyName `
    -Policy $policyFile `
    -Verbose

$resourceGroup = Get-AzureRmResourceGroup -Name 'contoso-paas'
$policy = Get-AzureRmPolicyDefinition -Name $policyName

New-AzureRmPolicyAssignment `
    -Name $policyAssignment `
    -PolicyDefinition $policy `
    -Scope $resourceGroup.ResourceId `
    -Verbose

}