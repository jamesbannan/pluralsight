provider "azurerm" {
  version = "=1.33.1"
}
terraform {
    backend "azurerm" {}
}