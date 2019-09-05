resource "random_id" "log_analytics_workspace_name_suffix" {
    byte_length = 8
}
resource "azurerm_log_analytics_workspace" "aks" {
    name                = "${var.log_analytics_workspace_name}-${random_id.log_analytics_workspace_name_suffix.dec}"
    location            = "${var.log_analytics_workspace_location}"
    resource_group_name = "${azurerm_resource_group.aks.name}"
    sku                 = "${var.log_analytics_workspace_sku}"

    lifecycle {
        ignore_changes = [
            name,
        ]
  }
}
resource "azurerm_log_analytics_solution" "aks-containerinsights" {
    solution_name         = "ContainerInsights"
    location              = "${azurerm_log_analytics_workspace.aks.location}"
    resource_group_name   = "${azurerm_resource_group.aks.name}"
    workspace_resource_id = "${azurerm_log_analytics_workspace.aks.id}"
    workspace_name        = "${azurerm_log_analytics_workspace.aks.name}"

    plan {
        publisher = "Microsoft"
        product   = "OMSGallery/ContainerInsights"
    }
}