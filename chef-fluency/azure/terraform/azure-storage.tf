resource "random_string" "storage_suffix" {
  length            = 6
  upper             = false
  special           = false
  min_lower         = 1
  min_numeric       = 1
}
resource "azurerm_storage_account" "storage-diag" {
    name                     = "chefvmdiag${random_string.storage_suffix.result}"
    resource_group_name      = "${azurerm_resource_group.chef.name}"
    location                 = "${azurerm_resource_group.chef.location}"
    account_tier             = "Standard"
    account_replication_type = "LRS"
}