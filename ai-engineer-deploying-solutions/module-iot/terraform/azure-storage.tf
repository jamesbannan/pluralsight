resource "random_id" "storage_account_name_suffix" {
    byte_length = 8
}
resource "random_id" "container_registry_name_suffix" {
    byte_length = 8
}
resource "azurerm_storage_account" "video" {
    name                     = "iot${random_id.storage_account_name_suffix.dec}"
    resource_group_name      = azurerm_resource_group.iot.name
    location                 = azurerm_resource_group.iot.location
    account_tier             = "Standard"
    account_replication_type = "LRS"

    lifecycle {
        ignore_changes = [
            name,
        ]
    }
}
resource "azurerm_storage_account" "diag" {
    name                     = "diag${random_id.storage_account_name_suffix.dec}"
    resource_group_name      = azurerm_resource_group.iot.name
    location                 = azurerm_resource_group.iot.location
    account_tier             = "Standard"
    account_replication_type = "LRS"

    lifecycle {
        ignore_changes = [
            name,
        ]
    }
}
resource "azurerm_storage_container" "example" {
    name                  = "videoblob"
    storage_account_name  = azurerm_storage_account.video.name
    container_access_type = "private"
}
resource "azurerm_container_registry" "acr" {
    name                     = "iot${random_id.container_registry_name_suffix.dec}"
    resource_group_name      = azurerm_resource_group.iot.name
    location                 = azurerm_resource_group.iot.location
    sku                      = "Standard"
    admin_enabled            = true

    lifecycle {
        ignore_changes = [
            name,
        ]
    }
}