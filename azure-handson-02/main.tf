# Configure the Azure Provider
provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version = ">= 2.41.0"
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "hjrg" {
  name     = var.resourcegroup
  location = var.location
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "vnet01" {
  name                = "hj-vnet01"
  resource_group_name = azurerm_resource_group.hjrg.name
  location            = azurerm_resource_group.hjrg.location
  address_space       = ["10.0.0.0/8"]
}

# Create Subnet
resource "azurerm_subnet" "subnet01" {
  name  = "hj-subnet01"
  resource_group_name = azurerm_resource_group.hjrg.name
  virtual_network_name = azurerm_virtual_network.vnet01.name
  address_prefixes = [ "10.1.0.0/16" ] 
}

# Create NSG
resource "azurerm_network_security_group" "nsg01" {
  name = "hj-nsg"
  location = azurerm_resource_group.hjrg.location
  resource_group_name = azurerm_resource_group.hjrg.name
  security_rule {
      name  = "RDP"
      priority  = 100
      direction = "Inbound"
      access  = "Allow"
      protocol  = "Tcp"
      source_port_range = "*"
      destination_port_range  = 3389
      source_address_prefix = "*"
      destination_address_prefix  = "*"
  }
  security_rule {  
      name  = "http"
      priority  = 110
      direction = "Inbound"
      access  = "Allow"
      protocol  = "Tcp"
      source_port_range = "*"
      destination_port_range  = 80
      source_address_prefix = "*"
      destination_address_prefix  = "*"
    }
  security_rule {  
      name  = "icmp"
      priority  = 120
      direction = "Inbound"
      access  = "Allow"
      protocol  = "Icmp"
      source_port_range = "*"
      destination_port_range  = "*"
      source_address_prefix = "*"
      destination_address_prefix  = "*"
    }
}
resource "azurerm_subnet_network_security_group_association" "nsg01_subnet01" {
  subnet_id = azurerm_subnet.subnet01.id
  network_security_group_id = azurerm_network_security_group.nsg01.id
}

# Create lb
resource "azurerm_public_ip" "extlb_pip" {
  name                = "PublicIPForLB"
  location            = var.location
  resource_group_name = var.resourcegroup
  allocation_method   = "Static"

  depends_on = [azurerm_resource_group.hjrg]
}

resource "azurerm_lb" "extlb_vmss" {
  name = "extlb-vmss"
  location = var.location
  resource_group_name = var.resourcegroup

  frontend_ip_configuration {
      name  =   "extlb-pip"
      public_ip_address_id = azurerm_public_ip.extlb_pip.id
  } 
}

resource "azurerm_lb_backend_address_pool" "extlb_bepool" {
  name  =   "extlb-bepool"  
  resource_group_name = var.resourcegroup
  loadbalancer_id = azurerm_lb.extlb_vmss.id
}

resource "azurerm_lb_probe" "extlb_hp" {
  name = "extlb-probe"
  resource_group_name = var.resourcegroup
  loadbalancer_id = azurerm_lb.extlb_vmss.id
  port = 80
  protocol = "http"
  request_path = "/"
}

resource "azurerm_lb_rule" "extlb_rule" {
    name = "extlb-rule"
    resource_group_name = var.resourcegroup
    loadbalancer_id = azurerm_lb.extlb_vmss.id
    frontend_port = 80
    backend_port = 80
    protocol = "Tcp"
    probe_id = azurerm_lb_probe.extlb_hp.id
    frontend_ip_configuration_name = azurerm_lb.extlb_vmss.frontend_ip_configuration[0].name
    backend_address_pool_id = azurerm_lb_backend_address_pool.extlb_bepool.id
}
resource "azurerm_lb_nat_pool" "extlb_natpool" {
  name = "extlb-natpool"
  resource_group_name = var.resourcegroup
  loadbalancer_id = azurerm_lb.extlb_vmss.id
  protocol = "Tcp"
  frontend_port_start = "5000"
  frontend_port_end = "5010"
  backend_port = 3389
  frontend_ip_configuration_name = azurerm_lb.extlb_vmss.frontend_ip_configuration[0].name
}

# Create Windows vmss
resource "azurerm_windows_virtual_machine_scale_set" "vmss" {
  name = "vmss"
  location = var.location
  resource_group_name = var.resourcegroup
  sku = "Standard_DS1_v2"
  instances = 2
  admin_username = "azureuser"
  admin_password = var.admin_password

  source_image_reference{
      publisher = "MicrosoftWindowsServer"
      offer = "WindowsServer"
      sku = "2016-Datacenter"
      version = "latest"
  }

  os_disk {
      storage_account_type = "Standard_LRS"
      caching   =   "ReadWrite"
  }

  network_interface {
      name = "vmss_nic"
      primary = true

      ip_configuration {
          name = "internal"
          primary = true
          subnet_id = azurerm_subnet.subnet01.id
          load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.extlb_bepool.id]
          load_balancer_inbound_nat_rules_ids = [azurerm_lb_nat_pool.extlb_natpool.id]
      }
  }
}
