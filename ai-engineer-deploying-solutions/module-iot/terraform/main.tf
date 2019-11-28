provider "azurerm" {
  version = "~>1.36.1"
}
terraform {
  backend "azurerm" {    
  }
}
data "azurerm_client_config" "current" {}