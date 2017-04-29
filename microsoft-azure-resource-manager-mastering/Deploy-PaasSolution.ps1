### Define variables
$location = 'Australia Southeast'
$resourceGroupName = 'pluralsight-arm-paas'
$resourceDeploymentName = 'pluralsight-arm-paas-deployment'
$templatePath = $env:USERPROFILE + '\Documents\git\pluralsight-azure-resource-manager-deep-dive'
$templateFile = 'paasDeploy_v2.json'
$template = $templatePath + '\' + $templateFile
$password = Read-Host -AsSecureString

$locations = @( `
    'East US', `
    'West Europe', `
    'Southeast Asia', `
    'Australia Southeast'
    )

### Define additional template parameters
$additionalParameters = New-Object -TypeName Hashtable
$additionalParameters['webAppLocation'] = $locations

### Create Resource Group
New-AzureRmResourceGroup `
    -Name $resourceGroupName `
    -Location $Location `
    -Verbose -Force

### Deploy Resources
New-AzureRmResourceGroupDeployment `
    -Name $resourceDeploymentName `
    -ResourceGroupName $resourceGroupName `
    -TemplateFile $template `
    @additionalParameters `
    -Verbose -Force