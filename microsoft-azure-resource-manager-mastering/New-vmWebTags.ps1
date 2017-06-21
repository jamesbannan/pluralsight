
### Get vmWeb VMs
{

$VMs = Get-AzureRmResource | `
    Where-Object {$_.Name -like "vmWeb-*" -and $_.ResourceType -eq 'Microsoft.Compute/virtualMachines'}

}

### Add Tags to Resources
{

$tags = New-Object -TypeName Hashtable
$tags += @{"department"="IT"}
$tags += @{"environment"="Production"}

foreach($VM in $VMs){
    Set-AzureRmResource `
        -Tag $tags `
        -ResourceId $VM.ResourceId
}

}