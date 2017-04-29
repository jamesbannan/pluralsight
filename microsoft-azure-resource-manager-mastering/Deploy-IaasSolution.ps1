### Define variables
$location = 'Australia Southeast'
$resourceGroupName = 'pluralsight-arm-iaas'
$resourceDeploymentADSolutionName = 'pluralsight-arm-iaas-deployment'
$templatePath = $env:USERPROFILE + '\Documents\git\pluralsight-azure-resource-manager-deep-dive'
$templateFileADSolution = 'iaasDeploy.json'
$templateADSolution = $templatePath + '\' + $templateFileADSolution
$sharedKey = 'hjkdkIUu33kmclLKSdj128'
$password = Read-Host -AsSecureString

### Define additional template parameters
$additionalParametersAD = New-Object -TypeName Hashtable
$additionalParametersAD['vmAdminPassword'] = $password
$additionalParametersAD['sharedKey'] = $sharedKey

### Create Resource Group
New-AzureRmResourceGroup `
    -Name $resourceGroupName `
    -Location $Location `
    -Verbose -Force

### Deploy Active Directory Solution
New-AzureRmResourceGroupDeployment `
    -Name $resourceDeploymentADSolutionName `
    -ResourceGroupName $resourceGroupName `
    -TemplateFile $templateADSolution `
    @additionalParametersAD `
    -Verbose -Force

### Deploy Active Directory Solution
New-AzureRmResourceGroupDeployment `
    -Name $resourceDeploymentADSolutionName `
    -ResourceGroupName $resourceGroupName `
    -TemplateFile $templateADSolution `
    @additionalParameters `
    -Verbose -Force