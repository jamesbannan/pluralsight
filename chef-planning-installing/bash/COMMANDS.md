
Bootstrapping Chef Nodes:

# Launching Linux and Windows clients
sudo ./Create-WindowsClientARM.sh
sudo ./Create-LinuxClientARM.sh

Deploy Client Servers in Chef-lab Azure Resource Group:

# Get Servers:
sudo azure vm list chef-lab:

  info:    Executing command vm list
  + Getting virtual machines                                                     
  data:    ResourceGroupName  Name            ProvisioningState  PowerState  Location  Size       
  data:    -----------------  --------------  -----------------  ----------  --------  -----------
  data:    chef-lab           chef-server     Succeeded          VM running  westus    Standard_D1
  data:    chef-lab           linux-client    Succeeded          VM running  westus    Standard_D1
  data:    chef-lab           windows-client  Succeeded          VM running  westus    Standard_D1
  info:    vm list command OK

# Get Public IP Address
sudo azure vm show chef-lab chef-server |grep "Public IP address" | awk -F ":" '{print $3}'
