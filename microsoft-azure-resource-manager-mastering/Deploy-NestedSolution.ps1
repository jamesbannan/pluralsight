### Define variables
$location = 'Australia Southeast'
$resourceGroupName = 'pluralsight-arm-nested'
$resourceDeploymentSolutionName = 'pluralsight-arm-nested-deployment'
$templateBaseUri = 'https://steamstorage01.blob.core.windows.net/resources'
$templateFile = 'azureDeploy.json'
$template = $templateBaseUri + '/' + $templateFile
$templateParametersFile = 'azureDeploy.parameters.json'
$templateParameters = $templateBaseUri + '/' + $templateParametersFile

### Create Resource Group
New-AzureRmResourceGroup `
    -Name $resourceGroupName `
    -Location $Location `
    -Verbose -Force

### Deploy IaaS Solution
New-AzureRmResourceGroupDeployment `
    -Name $resourceDeploymentSolutionName `
    -ResourceGroupName $resourceGroupName `
    -TemplateUri $template `
    -TemplateParameterUri $templateParameters `
    -Verbose -Force