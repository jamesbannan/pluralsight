data "azurerm_key_vault_secret" "vm-admin-password" {
    name         = "vm-admin-password"
    key_vault_id = "${azurerm_key_vault.key-vault.id}"
    depends_on   = [azurerm_key_vault_secret.vm-admin-password]
}
resource "azurerm_virtual_machine" "vm1" {
    name                    = "${var.vm1-name}"
    location                = "${azurerm_resource_group.chef.location}"
    resource_group_name     = "${azurerm_resource_group.chef.name}"

    lifecycle {
        ignore_changes = [
            os_profile,
        ]
    }

    network_interface_ids   = ["${azurerm_network_interface.vm1-nic.id}"]
    vm_size                 = "Standard_DS1_v2"

    delete_os_disk_on_termination       = true
    delete_data_disks_on_termination    = true

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }
    storage_os_disk {
        name              = "${var.vm1-name}-osDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }
    os_profile {
        computer_name  = "${var.vm1-name}"
        admin_username = "vmAdmin"
        admin_password = "${data.azurerm_key_vault_secret.vm-admin-password.value}"
    }
    os_profile_linux_config {
        disable_password_authentication = false
    }
    boot_diagnostics {
        enabled     = true
        storage_uri = "${azurerm_storage_account.storage-diag.primary_blob_endpoint}"
    }
}
resource "azurerm_virtual_machine" "vm2" {
    name                    = "${var.vm2-name}"
    location                = "${azurerm_resource_group.chef.location}"
    resource_group_name     = "${azurerm_resource_group.chef.name}"

    lifecycle {
        ignore_changes = [
            os_profile,
        ]
    }

    network_interface_ids   = ["${azurerm_network_interface.vm2-nic.id}"]
    vm_size                 = "Standard_DS1_v2"

    delete_os_disk_on_termination       = true
    delete_data_disks_on_termination    = true

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }
    storage_os_disk {
        name              = "${var.vm2-name}-osDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }
    os_profile {
        computer_name  = "${var.vm2-name}"
        admin_username = "vmAdmin"
        admin_password = "${data.azurerm_key_vault_secret.vm-admin-password.value}"
    }
    os_profile_linux_config {
        disable_password_authentication = false
    }
    boot_diagnostics {
        enabled     = true
        storage_uri = "${azurerm_storage_account.storage-diag.primary_blob_endpoint}"
    }
    zones   = []
}
