### Define variables
{

$location = 'Australia Southeast'
$resourceGroupName = 'contoso-arm-nested'
$resourceDeploymentSolutionName = 'contoso-arm-nested-deployment'
$templateBasePath = $env:SystemDrive + '\' + 'pluralsight' + '\' + 'nested'
$templateFile = 'azureDeploy.json'
$template = $templateBasePath + '\' + $templateFile
$templateParametersFile = 'azureDeploy.parameters.json'
$templateParameters = $templateBasePath + '\' + $templateParametersFile

}

### Create Resource Group
{

New-AzureRmResourceGroup `
    -Name $resourceGroupName `
    -Location $Location `
    -Verbose -Force

}

### Deploy IaaS Solution
{

New-AzureRmResourceGroupDeployment `
    -Name $resourceDeploymentSolutionName `
    -ResourceGroupName $resourceGroupName `
    -TemplateFile $template `
    -TemplateParameterFile $templateParameters `
    -Verbose -Force

}