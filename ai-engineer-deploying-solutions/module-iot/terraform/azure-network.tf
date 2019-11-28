resource "azurerm_virtual_network" "vnet" {
  name                = "iot-edge-vnet"
  location            = azurerm_resource_group.iot.location
  resource_group_name = azurerm_resource_group.iot.name
  address_space       = ["192.168.0.0/20"]
}
resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.iot.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = "192.168.0.0/24"
}
resource "azurerm_subnet" "iot" {
    name                 = "iot"
    resource_group_name  = azurerm_resource_group.iot.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefix       = "192.168.1.0/24"
}
resource "azurerm_network_security_group" "iot-edge" {
  name                = "iot-edge-nsg"
  location            = azurerm_resource_group.iot.location
  resource_group_name = azurerm_resource_group.iot.name
}
resource "azurerm_network_security_rule" "ssh-inbound" {
  name                        = "ssh-inbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.iot.name
  network_security_group_name = azurerm_network_security_group.iot-edge.name
}
resource "azurerm_network_security_rule" "video-inbound" {
  name                        = "video-inbound"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5012"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.iot.name
  network_security_group_name = azurerm_network_security_group.iot-edge.name
}
resource "azurerm_public_ip" "bastion-ip" {
  name                = "bastion-ip"
  location            = azurerm_resource_group.iot.location
  resource_group_name = azurerm_resource_group.iot.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
resource "azurerm_public_ip" "iot-edge-ip" {
  name                = "iot-edge-ip"
  location            = azurerm_resource_group.iot.location
  resource_group_name = azurerm_resource_group.iot.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}
resource "azurerm_network_interface" "iot-edge-nic" {
  name                = "iot-edge-nic-01"
  location            = azurerm_resource_group.iot.location
  resource_group_name = azurerm_resource_group.iot.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.iot.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.iot-edge-ip.id
  }
}
resource "azurerm_subnet_network_security_group_association" "iot-edge" {
  subnet_id                 = azurerm_subnet.iot.id
  network_security_group_id = azurerm_network_security_group.iot-edge.id
}