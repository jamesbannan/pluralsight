####################################################
#
# Script to deploy Carved Rock Fitness PaaS solution
#
####################################################

##############
### Demo 1 ###
##############

### Define Deployment Variables
$appNamePrefix = 'crf'
$locations = @(
    "eastus"
    "westus"
)

### Create ARM Resource Groups
ForEach ($location in $locations){
    $resourceGroupName = "$appNamePrefix-paas-$location"
    New-AzResourceGroup -Name $resourceGroupName -Location $location
}

### Create App Service Plans
ForEach ($location in $locations){
    $resourceGroupName = "$appNamePrefix-paas-$location"
    $appServicePlanName = "$appNamePrefix-plan-$location"

    New-AzAppServicePlan `
        -ResourceGroupName $resourceGroupName `
        -Location $location `
        -Name $appServicePlanName `
        -Tier Standard `
        -WorkerSize Small `
        -Linux 
}

### Create Web Apps
ForEach ($location in $locations){
    $resourceGroupName = "$appNamePrefix-paas-$location"
    $resourceGroupId = (Get-AzResourceGroup -ResourceGroupName $resourceGroupName).ResourceId
    
    $stream = [IO.MemoryStream]::new([byte[]][char[]]$resourceGroupId)
    $nameSuffix = (((Get-FileHash -InputStream $stream -Algorithm SHA256).Hash)[0..3] -Join '').ToLower()

    $webAppName = "$appNamePrefix-web-$location-$nameSuffix"
    $appServicePlanName = "$appNamePrefix-plan-$location"

    New-AzWebApp `
        -ResourceGroupName $resourceGroupName `
        -Location $location `
        -AppServicePlan $appServicePlanName `
        -Name $webAppName `
        -ContainerImageName 'nginx'
}