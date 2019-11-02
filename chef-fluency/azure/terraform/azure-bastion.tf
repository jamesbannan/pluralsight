resource "azurerm_bastion_host" "bastion" {
    name                = "vmbastion"
    location            = "${azurerm_resource_group.chef.location}"
    resource_group_name = "${azurerm_resource_group.chef.name}"

    ip_configuration {
        name                 = "networkconfig"
        subnet_id            = "${azurerm_subnet.bastion.id}"
        public_ip_address_id = "${azurerm_public_ip.bastion-ip.id}"
    }
}