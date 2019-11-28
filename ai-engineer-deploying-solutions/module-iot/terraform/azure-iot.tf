resource "random_id" "iothub_name_suffix" {
    byte_length = 8
}
resource "azurerm_iothub" "vision" {
    name                = "iot-vision-${random_id.iothub_name_suffix.dec}"
    resource_group_name = azurerm_resource_group.iot.name
    location            = azurerm_resource_group.iot.location

    sku {
        name     = "F1"
        tier     = "Free"
        capacity = "1"
    }

    lifecycle {
        ignore_changes = [
            name,
        ]
    }
}