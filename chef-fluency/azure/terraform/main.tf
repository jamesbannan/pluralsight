provider "azurerm" {
  version = "~>1.36.1"
}
provider "azuread" {
  version = "~>0.6.0"
}
terraform {
    backend "azurerm" {}
}
data "azurerm_client_config" "current" {}
