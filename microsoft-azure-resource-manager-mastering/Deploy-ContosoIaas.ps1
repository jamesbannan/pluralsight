### Define Deployment Variables
{
$location = 'Australia Southeast'
$resourceGroupName = 'contoso-iaas'
$resourceDeploymentName = 'contoso-iaas-deployment'
$templatePath = $env:SystemDrive + '\' + 'pluralsight'
$templateFile = 'contosoIaas.json'
$template = $templatePath + '\' + $templateFile
$password = "C0nts0sP@55"
$securePassword = $password | ConvertTo-SecureString -AsPlainText -Force
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

$additionalParameters = New-Object -TypeName Hashtable
$additionalParameters['vmAdminPassword'] = $securePassword

New-AzureRmResourceGroupDeployment `
    -Name $resourceDeploymentName `
    -ResourceGroupName $resourceGroupName `
    -TemplateFile $template `
    @additionalParameters `
    -Verbose -Force
}