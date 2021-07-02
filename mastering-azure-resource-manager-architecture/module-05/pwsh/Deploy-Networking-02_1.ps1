######################################################
#
# Script to deploy Carved Rock Fitness IaaS networking
#
######################################################

#######################
### Demo 2 - Part 1 ###
#######################

### Define Deployment Variables
$appNamePrefix = 'crf'
$locationDetails = Get-Content -Path '../locationDetails.json' | ConvertFrom-Json

### Deploy Storage Accounts
foreach ($i in $locationDetails) {
    $location = $i.Location
    $resourceGroupName = "$appNamePrefix-iaas-$location"
    $resourceGroup = Get-AzResourceGroup -Name $resourceGroupName
    $resourceGroupId = $resourceGroup.ResourceId

    $uniqueString = ((Get-FileHash -InputStream ([System.IO.MemoryStream]::New([System.Text.Encoding]::ASCII.GetBytes($resourceGroupId)))).Hash[0..4] -join '').ToLower()

    $storageAccountType = 'Standard_LRS'
    $storageAccountName = ($appNamePrefix + 'logs' + $storageAccountType.Replace('Standard_','') + $location + $uniqueString).ToLower()

    New-AzStorageAccount `
        -ResourceGroupName $resourceGroup.ResourceGroupName `
        -Location $resourceGroup.Location `
        -Name $storageAccountName `
        -Type $storageAccountType
}

### Deploy Network Security Groups
foreach ($i in $locationDetails) {
    $location = $i.Location
    $vNetName = "$appNamePrefix-vnet-$location"
    $resourceGroupName = "$appNamePrefix-iaas-$location"
    $vNetAddressPrefix = $i.AddressPrefix

    $subnetDetails = $i.Subnets | Where-Object {$_.Name -ne 'GatewaySubnet'}

    foreach ($subnet in $subnetDetails) {
        $subnetName = $subnet.Name
        $subnetPrefix = $subnet.SubnetPrefix
        $nsgName = "$subnetName-nsg"

        $nsg = New-AzNetworkSecurityGroup `
            -Name $nsgName `
            -ResourceGroupName $resourceGroupName `
            -Location $location `
            -Force

        $nsgRules = $subnet.NsgRules

        foreach ($rule in $nsgRules) {
            $nsg | Add-AzNetworkSecurityRuleConfig `
                -Name $rule.Name `
                -Description $rule.Description `
                -Access $rule.Access `
                -Protocol $rule.Protocol `
                -Direction $rule.Direction `
                -Priority $rule.Priority `
                -SourceAddressPrefix $rule.SourceAddressPrefix `
                -SourcePortRange $rule.SourcePortRange `
                -DestinationAddressPrefix $rule.DestinationAddressPrefix `
                -DestinationPortRange ($rule.DestinationPortRange).Split(",") | Set-AzNetworkSecurityGroup
        }
        
        $vNet = Get-AzVirtualNetwork -Name $vNetName -ResourceGroupName $resourceGroupName
        Set-AzVirtualNetworkSubnetConfig `
            -Name $subnetName `
            -VirtualNetwork $vNet `
            -AddressPrefix $subnetPrefix `
            -NetworkSecurityGroup $nsg
        $vNet | Set-AzVirtualNetwork
    }
}
