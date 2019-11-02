resource "azurerm_virtual_machine_extension" "vm1-chef-infra-client" {
    name                 = "ChefInfraClient"
    location             = "${azurerm_resource_group.chef.location}"
    resource_group_name  = "${azurerm_resource_group.chef.name}"
    virtual_machine_name = "${azurerm_virtual_machine.vm1.name}"
    publisher            = "Chef.Bootstrap.WindowsAzure"
    type                 = "LinuxChefClient"
    type_handler_version = "1210.12"

    settings = <<SETTINGS
        {
            "bootstrap_options": {
                "chef_server_url": "${var.chef_server_url}",
                "validation_client_name": "${var.chef_validation_client_name}",
                "chef_node_name": "${azurerm_virtual_machine.vm1.name}",
                "validation_key_format": "plaintext"
            }
        }
    SETTINGS

    protected_settings = <<PROTECTED_SETTINGS
        {
            "validation_key": ${jsonencode(file("${var.chef_validation_key_path}${var.chef_validation_client_name}.pem"))}
        }
    PROTECTED_SETTINGS
}
resource "azurerm_virtual_machine_extension" "vm2-chef-infra-client" {
    name                 = "ChefInfraClient"
    location             = "${azurerm_resource_group.chef.location}"
    resource_group_name  = "${azurerm_resource_group.chef.name}"
    virtual_machine_name = "${azurerm_virtual_machine.vm2.name}"
    publisher            = "Chef.Bootstrap.WindowsAzure"
    type                 = "LinuxChefClient"
    type_handler_version = "1210.12"

    settings = <<SETTINGS
        {
            "bootstrap_options": {
                "chef_server_url": "${var.chef_server_url}",
                "validation_client_name": "${var.chef_validation_client_name}",
                "chef_node_name": "${azurerm_virtual_machine.vm2.name}",
                "validation_key_format": "plaintext"
            }
        }
    SETTINGS

    protected_settings = <<PROTECTED_SETTINGS
        {
            "validation_key": ${jsonencode(file("${var.chef_validation_key_path}${var.chef_validation_client_name}.pem"))}
        }
    PROTECTED_SETTINGS
}