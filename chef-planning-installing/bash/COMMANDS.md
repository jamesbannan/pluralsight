
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

# Get private IP Address
ifconfig eth0 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1

# Connecting to Windows RDP via Ubuntu
  sudo add-apt-repository ppa:remmina-ppa-team/remmina-master
  sudo apt-get update
  sudo apt-get install remmina remmina-plugin-rdp



Bootstrap Client Servers Using Knife

# get the FQDN of linux server
sudo azure vm show chef-lab windows-client |grep "FQDN" | awk -F ":" '{print $3}'

# Knife adding
#Linux
note: if your password is wrong, it will just prompt you

#WinRM from ubuntu
note: does not require winrm quickconfig
note: when running knife commands with password, if you used symbols, wrap in single quotes (e.g. --ssh-password 'MYUNIQUEPASSWORD')


