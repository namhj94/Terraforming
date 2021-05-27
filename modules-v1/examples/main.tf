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

module "network" {
  source                = "./network"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = var.location
  vnet_name             = var.vnet_name
  address_space         = var.address_space
  subnet_name           = var.subnet_name
  subnet_address_prefix = var.subnet_address_prefix

  depends_on = [
    azurerm_resource_group.rg
  ]
}
module "nsg" {
  source              = "./nsg"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  nsg_name            = var.nsg_name

  # Default: Allow, TCP
  rule_name              = var.nsg_rule_name
  priority               = var.nsg_priority
  destination_port_range = var.nsg_destination_port_range
  subnet_id              = module.network.subnet_id
  depends_on = [
    azurerm_resource_group.rg
  ]
}

module "public-ip" {
  source              = "./public-ip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  pip_name            = var.pip_name
  pip_allocation_method   = var.allocation_method
  
  depends_on = [
    azurerm_resource_group.rg
  ]
}

module "linux" {
  source               = "./linux_server"
  resource_group_name  = azurerm_resource_group.rg.name
  hostname             = var.hostname
  location             = var.location
  size                 = var.size
  admin_username       = var.admin_username
  admin_password       = var.admin_password
  os_disk_sku          = var.os_disk_sku
  publisher            = var.publisher
  offer                = var.offer
  sku                  = var.sku
  tag                  = var.tag
  subnet_id            = module.network.subnet_id
  nic_name             = var.nic_name
  public_ip_address_id = module.public-ip.public_ip_address_id
  depends_on = [
    azurerm_resource_group.rg
  ]
}