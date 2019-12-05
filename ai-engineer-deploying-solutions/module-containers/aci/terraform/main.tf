provider "azurerm" {
  version = "~>1.36.1"
}
terraform {
  backend "azurerm" {    
  }
}