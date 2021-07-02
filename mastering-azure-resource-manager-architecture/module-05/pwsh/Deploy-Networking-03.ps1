######################################################
#
# Script to deploy Carved Rock Fitness IaaS networking
#
######################################################

##############
### Demo 3 ###
##############

### Define Deployment Variables
$appNamePrefix = 'crf'
$locationDetails = Get-Content -Path '../locationDetails.json' | ConvertFrom-Json

### Deploy Virtual Network Gateways
foreach ($i in $locationDetails) {
    $location = $i.Location
    $vNetName = "$appNamePrefix-vnet-$location"
    $resourceGroupName = "$appNamePrefix-iaas-$location"

    $vNet = Get-AzVirtualNetwork -Name $vNetName -ResourceGroupName $resourceGroupName

    $pipName = "$appNamePrefix-pip-$location"
    $pip = New-AzPublicIpAddress `
        -Name $pipName `
        -ResourceGroupName $resourceGroupName `
        -Location $location `
        -AllocationMethod Dynamic `
        -Force

    $gwSubnet = Get-AzVirtualNetworkSubnetConfig -Name 'GatewaySubnet' -VirtualNetwork $vNet
    $gwConfigName = "$appNamePrefix-gw-$location-config"
    $gwIpConfig = New-AzVirtualNetworkGatewayIpConfig `
        -Name $gwConfigName `
        -Subnet $gwSubnet `
        -PublicIpAddress $pip

    $gwName = "$appNamePrefix-gw-$location"

    New-AzVirtualNetworkGateway `
        -Name $gwName `
        -ResourceGroupName $resourceGroupName `
        -Location $location `
        -IpConfigurations $gwIpConfig `
        -GatewayType Vpn `
        -VpnType RouteBased `
        -GatewaySku VpnGw1
}

### Establish VNet-to-VNet Connection
foreach ($i in $locationDetails) {
    $location = $i.Location
    $resourceGroupName = "$appNamePrefix-iaas-$location"

    $localGateway = Get-AzVirtualNetworkGateway -ResourceGroupName $resourceGroupName

    $targetGatewayResource = Get-AzResource | Where-Object {$_.Type -eq 'Microsoft.Network/virtualNetworkGateways' -and $_.ResourceGroupName -ne $resourceGroupName}
    $targetGatewayName = $targetGatewayResource.Name
    $targetGatewayRG = $targetGatewayResource.ResourceGroupName
    $targetGateway = Get-AzVirtualNetworkGateway -Name $targetGatewayName -ResourceGroupName $targetGatewayRG

    $sharedKey = 'AzureVPN123'
    $connectionName = $localGateway.Name + '-to-' + $targetGateway.Name
    
    New-AzVirtualNetworkGatewayConnection `
        -Name $connectionName `
        -ResourceGroupName $resourceGroupName `
        -Location $location `
        -VirtualNetworkGateway1 $localGateway `
        -VirtualNetworkGateway2 $targetGateway `
        -ConnectionType Vnet2Vnet `
        -SharedKey $sharedKey
}
