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
  source                = "../../network"
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
  source              = "../../nsg"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  nsg_name            = "tf-nsg-test"

  rules = [
    {
      name                       = "ssh"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "211.215.58.26"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "22"
    },
    {
      name                       = "http"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "Internet"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "80,8080"
    },
    {
      name                         = "private_rule"
      priority                     = 120
      direction                    = "Inbound"
      access                       = "Allow"
      protocol                     = "Tcp"
      source_address_prefixes      = ["172.16.0.1", "172.16.0.2"]
      source_port_range            = "*"
      destination_address_prefixes = ["10.0.0.0/24", "192.168.0.1"]
      destination_port_range       = "3000,3001"
    }
  ]


  # if you want attach nsg to subnet, set true and subnet_id
  # of not want attach nsg to subnet, set false alone
  attach_to_subnet = [true, module.network.subnet_id]
  depends_on = [
    azurerm_resource_group.rg
  ]
}

module "public-ip" {
  source                = "../../public-ip"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = var.location
  pip_name              = var.pip_name
  pip_allocation_method = var.allocation_method

  depends_on = [
    azurerm_resource_group.rg
  ]
}

module "linux" {
  source               = "../../linux_server"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = var.location
  hostname             = var.hostname
  size                 = var.size
  admin_username       = var.admin_username
  admin_password       = var.admin_password
  os_disk_sku          = var.os_disk_sku
  publisher            = var.publisher
  offer                = var.offer
  sku                  = var.sku
  os_tag               = var.os_tag
  subnet_id            = module.network.subnet_id
  nic_name             = var.nic_name
  public_ip_address_id = module.public-ip.public_ip_address_id
  depends_on = [
    azurerm_resource_group.rg
  ]
}