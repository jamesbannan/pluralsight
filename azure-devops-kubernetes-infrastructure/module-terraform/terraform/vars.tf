variable location {
    description = "The location of the AKS Cluster solution."
    default     = "Australia East"
}
variable resource_group_name {
    description = "The name of the Azure Resource Group."
    default     = "demo-aks"
}
variable log_analytics_workspace_name {
    description = "The name of the Log Analytics workspace."
    default     = "aksmonitor"
}
# refer https://azure.microsoft.com/global-infrastructure/services/?products=monitor for log analytics available regions
variable log_analytics_workspace_location {
    description = "The location of the Log Analytics workspace."
    default     = "Australia East"
}
# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing 
variable log_analytics_workspace_sku {
    description = "The pricing SKU of the Log Analytics workspace."
    default     = "PerGB2018"
}
variable aks_cluster_name {
    description = "The name of the AKS cluster resource."
    default     = "demoCluster"
}
variable "public_ssh_key_path" {
    description = "The Path at which your Public SSH Key is located. Defaults to ~/.ssh/id_rsa.pub"
    default     = "~/.ssh/id_rsa.pub"
}