resource "azurerm_virtual_network" "demo" {
  name                = "${azurerm_resource_group.aks.name}-network"
  location            = "${azurerm_resource_group.aks.location}"
  resource_group_name = "${azurerm_resource_group.aks.name}"
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "cluster" {
  name                  = "cluster-01"
  resource_group_name   = "${azurerm_resource_group.aks.name}"
  address_prefix        = "10.1.0.0/24"
  virtual_network_name  = "${azurerm_virtual_network.demo.name}"
  route_table_id        = "${azurerm_route_table.cluster-01.id}"
}
resource "azurerm_route_table" "cluster-01" {
  name                = "${azurerm_resource_group.aks.name}-routetable"
  location            = "${azurerm_resource_group.aks.location}"
  resource_group_name = "${azurerm_resource_group.aks.name}"

  route {
    name                   = "cluster-01"
    address_prefix         = "10.100.0.0/14"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.10.1.1"
  }
}
resource "azurerm_subnet_route_table_association" "cluster-01" {
  subnet_id      = "${azurerm_subnet.cluster.id}"
  route_table_id = "${azurerm_route_table.cluster-01.id}"
}