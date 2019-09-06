resource "azurerm_kubernetes_cluster" "demo" {
    name                = "${var.aks_cluster_name}"
    location            = "${azurerm_resource_group.aks.location}"
    dns_prefix          = "ps-${var.aks_cluster_name}"
    resource_group_name = "${azurerm_resource_group.aks.name}"

    linux_profile {
        admin_username = "nodeadmin"

        ssh_key {
            key_data = "${file(var.public_ssh_key_path)}"
        }
    }

    agent_pool_profile {
        name            = "nodepool01"
        count           = "3"
        vm_size         = "Standard_DS2_v2"
        os_type         = "Linux"
        os_disk_size_gb = 30

        # Required for advanced networking
        vnet_subnet_id = "${azurerm_subnet.cluster.id}"
    }

    service_principal {
        client_id     = "${azuread_service_principal.sp-aks.application_id}"
        client_secret = "${random_string.sp-aks-password.result}"
    }

    network_profile {
        network_plugin = "azure"
    }

    addon_profile {
        oms_agent {
            enabled = true
            log_analytics_workspace_id = "${azurerm_log_analytics_workspace.aks.id}"
        }
    }
}