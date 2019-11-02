resource "random_string" "keyvault_suffix" {
    length          = 6
    min_lower       = 1
    min_numeric     = 1
    upper           = false
    special         = false
}
resource "random_string" "vm-admin-password" {
    length          = 16
    min_upper       = 1
    min_lower       = 1
    min_numeric     = 1
    special         = false
}
resource "azurerm_key_vault" "key-vault" {
    name                  = "${var.keyvault_name_prefix}-${random_string.keyvault_suffix.result}"
    location              = "${azurerm_resource_group.chef.location}"
    resource_group_name   = "${azurerm_resource_group.chef.name}"
    tenant_id             = "${data.azurerm_client_config.current.tenant_id}"

    lifecycle {
        ignore_changes = [
            name,
        ]
    }
    
    enabled_for_template_deployment = true

    sku_name = "${var.keyvault_sku}"

    access_policy {
        tenant_id = "${data.azurerm_client_config.current.tenant_id}"
        object_id = "${data.azurerm_client_config.current.object_id}"
        certificate_permissions = "${var.certificate_permissions_all}"
        key_permissions = "${var.key_permissions_all}"
        secret_permissions = "${var.secret_permissions_all}"
    }
}
resource "azurerm_key_vault_secret" "vm-admin-password" {
    name         = "vm-admin-password"
    value        = "${random_string.vm-admin-password.result}"
    key_vault_id = "${azurerm_key_vault.key-vault.id}"

    lifecycle {
        ignore_changes = [
            value,
        ]
    }
}
