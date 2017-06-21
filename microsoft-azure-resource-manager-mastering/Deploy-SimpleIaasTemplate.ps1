### Define Deployment Variables
{
$location = 'Australia Southeast'
$resourceGroupName = 'contoso-simple-iaas-template'
$resourceDeploymentName = 'contoso-iaas-template-deployment'
$templatePath = $env:SystemDrive + '\' + 'pluralsight'
$templateFile = 'simpleiaas.json'
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