######################################################
#
# Script to deploy Carved Rock Fitness IaaS networking
#
######################################################

##############
### Demo 1 ###
##############

### Define Deployment Variables
$appNamePrefix = 'crf'
$locationDetails = Get-Content -Path '../locationDetails.json' | ConvertFrom-Json

### Deploy Resource Groups
foreach ($i in $locationDetails) {
    $location = $i.Location
    $resourceGroupName = "$appNamePrefix-iaas-$location"
    New-AzResourceGroup -Name $resourceGroupName -Location $location -Force
}

### Deploy Virtual Networks
foreach ($i in $locationDetails) {
    $location = $i.Location
    $vNetName = "$appNamePrefix-vnet-$location"
    $resourceGroupName = "$appNamePrefix-iaas-$location"
    $vNetAddressPrefix = $i.AddressPrefix

    New-AzVirtualNetwork `
        -Name $vNetName `
        -Location $location `
        -ResourceGroupName $resourceGroupName `
        -AddressPrefix $vNetAddressPrefix
}

### Deploy Virtual Network Subnets
foreach ($i in $locationDetails) {
    $location = $i.Location
    $vNetName = "$appNamePrefix-vnet-$location"
    $resourceGroupName = "$appNamePrefix-iaas-$location"
    $vNetAddressPrefix = $i.AddressPrefix

    $subnetDetails = $i.Subnets

    foreach ($subnet in $subnetDetails) {
        $subnetName = $subnet.Name
        $subnetPrefix = $subnet.SubnetPrefix

        $vNet = Get-AzVirtualNetwork -Name $vNetName -ResourceGroupName $resourceGroupName
        $subnetConfig = Add-AzVirtualNetworkSubnetConfig `
            -Name $subnetName `
            -AddressPrefix $subnetPrefix `
            -VirtualNetwork $vNet
        $vNet | Set-AzVirtualNetwork
    }
}