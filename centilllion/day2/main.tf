terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "sample" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "adls" {
  name                     = "sampleadlsaccount"
  resource_group_name      = azurerm_resource_group.sample.name
  location                 = azurerm_resource_group.sample.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = true

  identity {
    type = "SystemAssigned"
  }
}
