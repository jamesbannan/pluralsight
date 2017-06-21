### Define Deployment Variables
{
$resourceGroupLocation = 'Australia Southeast'
$resourceGroupName = 'contoso-paas'
$resourceDeploymentName = 'contoso-paas-deployment'
$templatePath = $env:SystemDrive + '\' + 'pluralsight'
$templateFile = 'contosoPaas.json'
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