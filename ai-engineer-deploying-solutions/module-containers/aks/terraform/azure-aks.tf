resource "azurerm_kubernetes_cluster" "aks" {
    name                = "ps-aks"
    location            = azurerm_resource_group.aks.location
    dns_prefix          = "ps-aks"
    resource_group_name = azurerm_resource_group.aks.name

    linux_profile {
        admin_username = "nodeadmin"

        ssh_key {
            key_data = tls_private_key.aks.public_key_openssh
        }
    }

    agent_pool_profile {
        name                = "nodepool01"
        count               = "1"
        type                = "VirtualMachineScaleSets"
        enable_auto_scaling = true
        min_count           = 1
        max_count           = 5
        vm_size             = "Standard_DS1_v2"
        os_type             = "Linux"
        os_disk_size_gb     = 30

        vnet_subnet_id      = azurerm_subnet.nodepool-01.id
    }

    service_principal {
        client_id     = azuread_service_principal.sp-aks.application_id
        client_secret = random_string.sp-aks-password.result
    }

    network_profile {
        network_plugin = "azure"
    }

    addon_profile {
        oms_agent {
            enabled = true
            log_analytics_workspace_id = azurerm_log_analytics_workspace.aks.id
        }
    }
}