resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vnet_name}"
  location            = "${azurerm_resource_group.chef.location}"
  resource_group_name = "${azurerm_resource_group.chef.name}"
  address_space       = ["192.168.0.0/20"]
}
resource "azurerm_subnet" "bastion" {
    name                 = "AzureBastionSubnet"
    resource_group_name  = "${azurerm_resource_group.chef.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefix       = "192.168.0.0/24"
}
resource "azurerm_subnet" "vms" {
    name                 = "vms"
    resource_group_name  = "${azurerm_resource_group.chef.name}"
    virtual_network_name = "${azurerm_virtual_network.vnet.name}"
    address_prefix       = "192.168.1.0/24"
}
resource "azurerm_network_security_group" "chef-vms" {
  name                = "demo-chef-nsg"
  location            = "${azurerm_resource_group.chef.location}"
  resource_group_name = "${azurerm_resource_group.chef.name}"
}
resource "azurerm_network_security_rule" "ssh-inbound" {
  name                        = "ssh-inbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.chef.name}"
  network_security_group_name = "${azurerm_network_security_group.chef-vms.name}"
}
resource "azurerm_public_ip" "bastion-ip" {
  name                = "bastion-ip"
  location            = "${azurerm_resource_group.chef.location}"
  resource_group_name = "${azurerm_resource_group.chef.name}"
  allocation_method   = "Static"
  sku                 = "Standard"
}
resource "azurerm_network_interface" "vm1-nic" {
  name                = "${var.vm1-name}-nic-01"
  location            = "${azurerm_resource_group.chef.location}"
  resource_group_name = "${azurerm_resource_group.chef.name}"

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${azurerm_subnet.vms.id}"
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_network_interface" "vm2-nic" {
  name                = "${var.vm2-name}-nic-01"
  location            = "${azurerm_resource_group.chef.location}"
  resource_group_name = "${azurerm_resource_group.chef.name}"

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${azurerm_subnet.vms.id}"
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_subnet_network_security_group_association" "vms" {
    subnet_id                 = "${azurerm_subnet.vms.id}"
    network_security_group_id = "${azurerm_network_security_group.chef-vms.id}"
}