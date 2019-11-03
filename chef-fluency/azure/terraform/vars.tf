variable location {
    description = "The location of the AKS Cluster solution."
    default     = "Australia East"
}
variable resource_group_name {
    description = "The name of the Azure Resource Group."
    default     = "demo-chef"
}
variable vnet_name {
    description = "The name of the Azure virtual network."
    default     = "demo-vnet"
}
variable keyvault_name_prefix {
    description = "The name of the Azure Key Vault."
    default     = "demo-vault"
}
variable keyvault_sku {
  description = "The SKU of the Azure Key Vault which will be created."
  default = "standard"  
}
variable certificate_permissions_all {
  type          = "list"
  description   = "Certificate action permissions in the Key Vault."
  default       = [
      "create",
      "delete",
      "deleteissuers",
      "get",
      "getissuers",
      "import",
      "list",
      "listissuers",
      "managecontacts",
      "manageissuers",
      "purge",
      "recover",
      "setissuers",
      "update"
  ]
}
variable key_permissions_all {
  type          = "list"
  description   = "Key action permissions in the Key Vault."
  default       = [
      "backup",
      "create",
      "decrypt",
      "delete",
      "encrypt",
      "get",
      "import",
      "list",
      "purge",
      "recover",
      "restore",
      "sign",
      "unwrapKey",
      "update",
      "verify",
      "wrapKey"
  ]
}
variable secret_permissions_all {
  type          = "list"
  description   = "Secret action permissions in the Key Vault."
  default       = [
      "backup",
      "delete",
      "get",
      "list",
      "purge",
      "recover",
      "restore",
      "set"
  ]
}
variable vm1-name {
  type        = "string"
  description = "Name of the first virtual machine."
  default     = "chef-vm-01"
}
variable vm2-name {
  type        = "string"
  description = "Name of the second virtual machine."
  default     = "chef-vm-02"
}
variable chef_validation_key_path {
  type        = "string"
  description = "(Required) Absolute path to the folder containing Chef organisation validation PEM file - use double backslashes if Windows."
  default     = ""
}
variable chef_server_url {
  type        = "string"
  description = "(Required) URL of the Chef Infra Server instance including the organisation (e.g. https://api.chef.io/organizations/<MY_ORG>)."
  default     = ""
}
variable chef_validation_client_name {
  type        = "string"
  description = "(Required) The name of the validation client, usually the org name plan '-validator' (e.g. myorg-validator)."
  default     = ""
}