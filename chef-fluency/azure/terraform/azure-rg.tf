resource "azurerm_resource_group" "chef" {
    name     = "${var.resource_group_name}"
    location = "${var.location}"
}