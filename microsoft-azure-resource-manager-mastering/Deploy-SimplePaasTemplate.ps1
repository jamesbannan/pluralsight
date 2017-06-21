### Define Deployment Variables
{
$location = 'Australia Southeast'
$resourceGroupName = 'contoso-simple-paas-template'
$resourceDeploymentName = 'contoso-paas-template-deployment'
$templatePath = $env:SystemDrive + '\' + 'pluralsight'
$templateFile = 'simplePaas.json'
$template = $templatePath + '\' + $templateFile
}

### Create Resource Group
{
New-AzureRmResourceGroup `
    -Name $resourceGroupName `
    -Location $location `
    -Verbose -Force
}

### Deploy Resources
{
New-AzureRmResourceGroupDeployment `
    -Name $resourceDeploymentName `
    -ResourceGroupName $resourceGroupName `
    -TemplateFile $template `
    -Verbose -Force
}