function New-RandomString {
    $String = $null
    $r = New-Object System.Random
    1..6 | % { $String += [char]$r.next(97,122) }
    $string
}

### Declare Variables ###

$VMName = 'chef-server'
$VMSize = 'Large' # Specify one: Small, Medium, Large, ExtraLarge, A5, A6, A7, A8, A9
$Location = 'Australia Southeast' # Use Get-AzureLocation for a complete list
$ImageFamily = 'Ubuntu Server 14.04 LTS'
$cred = Get-Credential -Message 'Type the name and password of the initial Linux account (e.g. chef/P@ssw0rd).'
$ServiceLabel = 'Chef Lab Resources'
$SubscriptionName = 'Visual Studio Ultimate with MSDN'

### Generate Service & Storage Name ###

$ServiceName = 'pluralsight-chef-' + (New-RandomString)
$StorageName = 'chefstorage1' + (New-RandomString)
$AffinityGroupName = 'affinitygroup1' + (New-RandomString)

### Create Azure Service ###

if((Test-AzureName -Service $ServiceName) -eq $false){
    New-AzureService -ServiceName $ServiceName -Label $ServiceLabel -Location $Location -Verbose
    $AzureService = Get-AzureService -ServiceName $ServiceName
    }
    else {$AzureService = Get-AzureService -ServiceName $ServiceName}

### Create Azure Storage ###

if((Test-AzureName -Storage $StorageName) -eq $false){
    New-AzureAffinityGroup -Name $AffinityGroupName -Location $Location -Label $ServiceLabel -Verbose
    $AffinityGroup = Get-AzureAffinityGroup -Name $AffinityGroupName
    New-AzureStorageAccount -StorageAccountName $StorageName -Label $ServiceLabel -Type Standard_LRS -AffinityGroup $AffinityGroupName -Verbose
    $AzureStorage = Get-AzureStorageAccount -StorageAccountName $StorageName
    }
    else {$AzureStorage = Get-AzureStorageAccount -StorageAccountName $StorageName}

### Create chef-server Base VM ###

Set-AzureSubscription -SubscriptionName $SubscriptionName -CurrentStorageAccount $StorageName
$VMImage = Get-AzureVMImage | Where-Object { $_.ImageFamily -eq $ImageFamily } | Sort-Object PublishedDate -Descending | Select-Object -ExpandProperty ImageName -First 1
Write-Host 'Using Linux image' $VMImage
$VM = New-AzureVMConfig -Name $VMName -InstanceSize $VMSize -ImageName $VMImage
$VM | Add-AzureProvisioningConfig -Linux -LinuxUser $cred.GetNetworkCredential().Username -Password $cred.GetNetworkCredential().Password | Out-Null
$VM | Add-AzureEndpoint -Protocol tcp -LocalPort 80 -PublicPort 80 -Name HTTP
$VM | Add-AzureEndpoint -Protocol tcp -LocalPort 443 -PublicPort 443 -Name HTTPS
New-AzureVM –ServiceName $ServiceName -VMs $VM -Verbose -WaitForBoot
$ChefServer = Get-AzureVM -ServiceName $ServiceName -Name $VMName