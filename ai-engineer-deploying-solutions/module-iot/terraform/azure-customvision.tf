resource "azurerm_resource_group" "iot" {
    name     = "iot-solution"
    location = "Australia East"
}

resource "azurerm_cognitive_account" "vision" {
    name                = "iot-vision"
    location            = azurerm_resource_group.iot.location
    resource_group_name = azurerm_resource_group.iot.name
    kind                = "CustomVision.Training"

    sku {
        name = "F0"
        tier = "Standard"
    }
}