terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.60.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

module "nsg" {
  source              = "../../nsg"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  nsg_name = "terraform-nsg"

  rules = [
    {
      name = "ssh"
      priority = 100
      direction = "Inbound"
      access = "Allow"
      protocol = "Tcp"
      source_address_prefix = "211.215.58.26"
      source_port_range = "*"
      destination_address_prefix = "*"
      destination_port_range = "22"
    },
    {
      name = "http"
      priority = 110
      direction = "Inbound"
      access = "Allow"
      protocol = "Tcp"
      source_address_prefix = "Internet"
      source_port_range = "*"
      destination_address_prefix = "*"
      destination_port_range = "80,8080"
    },
    {
      name = "private_rule"
      priority = 120
      direction = "Inbound"
      access = "Allow"
      protocol = "Tcp"
      source_address_prefixes = ["172.16.0.1", "172.16.0.2"]
      source_port_range = "*"
      destination_address_prefixes = ["10.0.0.0/24", "192.168.0.1"]
      destination_port_range = "3000,3001"
    }
  ]
  
  depends_on = [
    azurerm_resource_group.rg
  ]
}