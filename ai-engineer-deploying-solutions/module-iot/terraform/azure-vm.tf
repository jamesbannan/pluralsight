data "azurerm_key_vault_secret" "vm-admin-password" {
    name         = "vm-admin-password"
    key_vault_id = "${azurerm_key_vault.key-vault.id}"
    depends_on   = [azurerm_key_vault_secret.vm-admin-password]
}
resource "azurerm_virtual_machine" "iot-edge" {
    name                    = "iot-edge"
    location                = azurerm_resource_group.iot.location
    resource_group_name     = azurerm_resource_group.iot.name

    lifecycle {
        ignore_changes = [
            os_profile,
        ]
    }

    network_interface_ids   = ["${azurerm_network_interface.iot-edge-nic.id}"]
    vm_size                 = "Standard_DS1_v2"

    delete_os_disk_on_termination       = true
    delete_data_disks_on_termination    = true

    storage_image_reference {
        publisher = "microsoft_iot_edge"
        offer     = "iot_edge_vm_ubuntu"
        sku       = "ubuntu_1604_edgeruntimeonly"
        version   = "1.0.1"
    }
    plan {
        name        = "ubuntu_1604_edgeruntimeonly"
        publisher   = "microsoft_iot_edge"
        product     = "iot_edge_vm_ubuntu"
    }
    storage_os_disk {
        name              = "iot-edge-osDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }
    os_profile {
        computer_name  = "iot-edge"
        admin_username = "vmAdmin"
        admin_password = data.azurerm_key_vault_secret.vm-admin-password.value
    }
    os_profile_linux_config {
        disable_password_authentication = false
    }
    boot_diagnostics {
        enabled     = true
        storage_uri = azurerm_storage_account.diag.primary_blob_endpoint
    }
}
resource "null_resource" "iot-device-registration" {
  provisioner "local-exec" {
      command = "./scripts/registerEdgeDevice.sh ${azurerm_resource_group.iot.name} iot-vision-${random_id.iothub_name_suffix.dec} iot-edge"
  }
  depends_on    = [azurerm_virtual_machine.iot-edge]
}