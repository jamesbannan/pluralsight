#!/bin/bash

# Prompt user for input
echo -n "Enter the Azure AD username and press [ENTER]: "
read azureloginuname
echo -n "Enter the password and press [ENTER]: "
read azureloginpass

# Generate random string

function randompass () {
        local randompassLength
        if [ $1 ]; then
                randompassLength=$1
        else
                randompassLength=8
        fi

        pass=</dev/urandom tr -dc A-Za-z0-9 | head -c $randompassLength
        echo $pass
}

randomString=`randompass 6`

name="$staticString-$randomString"

# Set variable values based on parameters passed
azuresubname="$3" # Azure subscription name
azureregion="$4" # Azure datacenter region
azureprefix="$5" # Unique prefix for Azure resource names
azurevmuname="$6" # Admin username for new VMs
azurevmpass="$7" # Admin password for new VMs
azurevmtotal="$8" # Number of VMs to provision
azurecloudinit="$9" # Cloud-Init config file

# Sign-in to Azure account with Azure AD credentials

azure login --username "$azureloginuname" --password "$azureloginpass"

# Confirm that Azure account sign-in was successful

if [ "$?" != "0" ]; then
    echo "Error: login to Azure account failed"
    exit 1
fi

# Select Azure subscription

azure account set "$azuresubname"

# Confirm that subscription is now default

azuresubdefault=$(azure account show --json "$azuresubname" | jsawk 'return this.isDefault')
if [ "$azuresubdefault" != "true" ]; then
    echo "Error: Azure subscription ${azuresubdefault} not found as default subscription"
    exit 1
fi

# Define Azure affinity group

azureagname="${azureprefix}ag"
azure account affinity-group create --location "$azureregion" --label "$azureagname" "$azureagname"

# Confirm that Azure affinity group exists

azureagexist=$(azure account affinity-group list --json | jsawk 'return true' -q "[?name=\"$azureagname\"]")
if [ $azureagexist != [true] ]; then
    echo "Error: Azure affinity group ${azureagname} not found"
    exit 1
fi

# Create Azure storage account

azurestoragename="${azureprefix}stor"
azure storage account create --affinity-group "$azureagname" --label "$azurestoragename" --geoReplication "$azurestoragename"

# Confirm that Azure storage account exists

azurestorageexist=$(azure storage account list --json | jsawk 'return true' -q "[?name=\"$azurestoragename\"]")
if [ $azurestorageexist != [true] ]; then
    echo "Error: Azure storage account ${azurestoragename} not found"
    exit 1
fi

# Create Azure virtual network

azurevnetname="${azureprefix}net"
azure network vnet create --affinity-group "$azureagname" "$azurevnetname"

# Confirm that Azure virtual network exists

azurevnetexist=$(azure network vnet list --json | jsawk 'return true' -q "[?name=\"$azurevnetname\"]")
if [ $azurevnetexist != [true] ]; then
    echo "Error: Azure virtual network ${azurevnetname} not found"
    exit 1
fi

# Select Linux VM image

azurevmimage=$(azure vm image list --json | jsawk -n 'out(this.name)' -q "[?name=\"*Ubuntu-14_04_1-LTS-amd64-server*\"]" | sort | tail -n 1)

# Confirm that valid Linux VM Image is selected

if [ "$azurevmimage" = "" ]; then
    echo "Error: Azure VM image not found"
    exit 1
fi

# Set variables for provisioning Linux VMs

azurednsname="${azureprefix}app" # DNS hostname for Cloud Service
azurevmsize='Small' # Azure VM instance size
azureavailabilityset="${azureprefix}as" # Availability Set name
azureendpointport='80' # Port to Load-balance
azureendpointprot='tcp' # Protocol to Load-balance
azureendpointdsr='false' # Direct Server Return, usually false
azureloadbalanceset="${azureprefix}lb" # Load-balanced Set name

# Provision Linux VMs

# Initialize Azure VM counter
azurevmcount=1

# Loop through provisioning each VM
while [ $azurevmcount -le $azurevmtotal ]
do

   # Set Linux VM hostname
    azurevmname="${azureprefix}app${azurevmcount}"

    # Create Linux VM - if first VM, also create Azure Cloud Service
    if [ $azurevmcount -eq 1 ]; then
        azure vm create --vm-name "$azurevmname" --affinity-group "$azureagname" --virtual-network-name "$azurevnetname" --availability-set "$azureavailabilityset" --ssh 22 --custom-data "$azurecloudinit" --vm-size "$azurevmsize" "$azurednsname" "$azurevmimage" "$azurevmuname" "$azurevmpass"
    else
        azure vm create --vm-name "$azurevmname" --affinity-group "$azureagname" --virtual-network-name "$azurevnetname" --availability-set "$azureavailabilityset" --ssh $((22+($azurevmcount-1))) --custom-data "$azurecloudinit" --vm-size "$azurevmsize" --connect "$azurednsname" "$azurevmimage" "$azurevmuname" "$azurevmpass"
    fi

    # Confirm that VM creation was successfully submitted
    if [ "$?" != "0" ]; then
        echo "Error: provisioning VM ${azurevmname} failed"
        exit 1
    fi

    # Define load-balancing for incoming web traffic on each VM
    azure vm endpoint create-multiple "$azurevmname" $azureendpointport:$azureendpointport:$azureendpointprot:$azureendpointdsr:$azureloadbalanceset:$azureendpointprot:$azureendpointport

    # Confirm that load-balancing config was successfully submitted
    if [ "$?" != "0" ]; then
        echo "Error: provisioning endpoints for VM ${azurevmname} failed"
        exit 1
    fi

    # Wait until new VM is in a Running state
    azurevmstatus='None'
    while [ "$azurevmstatus" != "ReadyRole" ]
    do
        sleep 30s
        azurevmstatus=$(azure vm show --json --dns-name "$azurednsname" "$azurevmname" | jsawk 'return this.InstanceStatus')
        echo "Provisioning: ${azurevmname} status is ${azurevmstatus}"
    done

    # Increment VM counter for next VM
    azurevmcount=$((azurevmcount+1))

done
