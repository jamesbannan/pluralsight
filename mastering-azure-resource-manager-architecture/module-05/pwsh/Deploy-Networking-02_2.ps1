######################################################
#
# Script to deploy Carved Rock Fitness IaaS networking
#
######################################################

#######################
### Demo 2 - Part 2 ###
#######################

### Define Deployment Variables
$appNamePrefix = 'crf'
$locationDetails = Get-Content -Path '../locationDetails.json' | ConvertFrom-Json

### Enable Virtual Network Diagnostics
foreach ($i in $locationDetails) {
    $location = $i.Location
    $vNetName = "$appNamePrefix-vnet-$location"
    $resourceGroupName = "$appNamePrefix-iaas-$location"

    $vNet = Get-AzVirtualNetwork -Name $vNetName -ResourceGroupName $resourceGroupName
    $storageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroupName | Where-Object {$_.StorageAccountName -like "*logs*"}

    $metrics = New-AzDiagnosticDetailSetting `
        -Metric `
        -RetentionInDays 90 `
        -RetentionEnabled `
        -Category AllMetrics `
        -Enabled

    $logs = New-AzDiagnosticDetailSetting `
        -Log `
        -RetentionInDays 90 `
        -RetentionEnabled `
        -Category VMProtectionAlerts `
        -Enabled

    $diagnostics = New-AzDiagnosticSetting `
        -Name 'vNetDiagnostics' `
        -ResourceId $vNet.Id `
        -StorageAccountId $storageAccount.Id `
        -Setting $metrics,$logs

    Set-AzDiagnosticSetting -InputObject $diagnostics
}

### Enable NSG Diagnostics
foreach ($i in $locationDetails) {
    $location = $i.Location
    $resourceGroupName = "$appNamePrefix-iaas-$location"

    $storageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroupName | Where-Object {$_.StorageAccountName -like "*logs*"}

    $logs1 = New-AzDiagnosticDetailSetting `
        -Log `
        -RetentionInDays 90 `
        -RetentionEnabled `
        -Category NetworkSecurityGroupEvent `
        -Enabled

    $logs2 = New-AzDiagnosticDetailSetting `
        -Log `
        -RetentionInDays 90 `
        -RetentionEnabled `
        -Category NetworkSecurityGroupRuleCounter `
        -Enabled

    $nsgs = Get-AzNetworkSecurityGroup -ResourceGroupName $resourceGroupName

    foreach ($nsg in $nsgs){
        $diagnostics = New-AzDiagnosticSetting `
            -Name 'nsgDiagnostics' `
            -ResourceId $nsg.Id `
            -StorageAccountId $storageAccount.Id `
            -Setting $logs1,$logs2
        Set-AzDiagnosticSetting -InputObject $diagnostics
    }
}

### Enable Network Watcher
foreach ($i in $locationDetails) {
    $location = $i.Location
    $resourceGroupName = "$appNamePrefix-iaas-$location"

    $storageAccount = Get-AzStorageAccount -ResourceGroupName $resourceGroupName | Where-Object {$_.StorageAccountName -like "*logs*"}

    $networkWatcher = Get-AzNetworkWatcher `
        -ResourceGroupName 'NetworkWatcherRG' `
        -Name "NetworkWatcher_$location"

    $nsgs = Get-AzNetworkSecurityGroup -ResourceGroupName $resourceGroupName

    foreach ($nsg in $nsgs) {
        Set-AzNetworkWatcherConfigFlowLog `
            -NetworkWatcher $networkWatcher `
            -TargetResourceId $nsg.Id `
            -StorageAccountId $storageAccount.Id `
            -EnableFlowLog $true `
            -FormatType Json `
            -FormatVersion 1
    }
}