terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.44.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "lethiCreation" {
  name     = "lethiCreation"
  location = "West Europe"
}

resource "azurerm_network_security_group" "snet" {
  name                = "snet"
  location            = azurerm_resource_group.lethiCreation.location
  resource_group_name = azurerm_resource_group.lethiCreation.name
}

resource "azurerm_virtual_network" "example" {
  name                = "VNET"
  location            = azurerm_resource_group.lethiCreation.location
  resource_group_name = azurerm_resource_group.lethiCreation.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.1.0/24"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.2.0/24"
    security_group = azurerm_network_security_group.snet.id
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_security_group" "SGRoup" {
  name                = "SGRoup"
  location            = azurerm_resource_group.lethiCreation.location
  resource_group_name = azurerm_resource_group.lethiCreation.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "gpedev" {
  name                     = "lethidevelopment"
  resource_group_name      = azurerm_resource_group.lethiCreation.name
  location                 = azurerm_resource_group.lethiCreation.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = true
}

resource "azurerm_storage_data_lake_gen2_filesystem" "example_fs" {
  name               = "lethistorage"  # Change to a unique name
  storage_account_id = azurerm_storage_account.gpedev.id

  properties = {
    hello = "aGVsbG8="
  }
}

resource "azurerm_data_factory" "example" {
  name                = "lethiCreation-data-factory"
  location            = azurerm_resource_group.lethiCreation.location
  resource_group_name = azurerm_resource_group.lethiCreation.name

  tags = {
    "terraform"    = "terraform"
    "environment"  = "Production"
  }
}

resource "azurerm_data_factory_pipeline" "example" {
  name               = "Creation-data-pipeline"
  data_factory_name  = azurerm_data_factory.example.name
  resource_group_name = azurerm_resource_group.lethiCreation.name
}