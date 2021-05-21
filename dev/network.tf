# Create a resource group
resource "azurerm_resource_group" "web_rg" {
  name     = var.resourcegroup
  location = var.location
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "dev_vnet" {
  name                = "${var.prefix}-vnet"
  resource_group_name = azurerm_resource_group.web_rg.name
  location            = azurerm_resource_group.web_rg.location
  address_space       = ["10.0.0.0/16"]
}

# Create Subnet
resource "azurerm_subnet" "dev_front_subnet" {
  name  = "${var.prefix}-front-subnet"
  resource_group_name = azurerm_resource_group.web_rg.name
  virtual_network_name = azurerm_virtual_network.dev_vnet.name
  address_prefixes = [ "10.0.0.0/24" ] 
}

# Create NSG
resource "azurerm_network_security_group" "dev_front_nsg" {
  name = "${var.prefix}-front-nsg"
  location = azurerm_resource_group.web_rg.location
  resource_group_name = azurerm_resource_group.web_rg.name
  security_rule {
      name  = "SSH"
      priority  = 100
      direction = "Inbound"
      access  = "Allow"
      protocol  = "Tcp"
      source_port_range = "*"
      destination_port_range  = 22
      source_address_prefix = var.src_ip
      destination_address_prefix  = "*"
  }
  security_rule {  
      name  = "http"
      priority  = 120
      direction = "Inbound"
      access  = "Allow"
      protocol  = "Tcp"
      source_port_range = "*"
      destination_port_range  = 80
      source_address_prefix = "*"
      destination_address_prefix  = "*"
    }
      security_rule {  
      name  = "https"
      priority  = 130
      direction = "Inbound"
      access  = "Allow"
      protocol  = "Tcp"
      source_port_range = "*"
      destination_port_range  = 443
      source_address_prefix = "*"
      destination_address_prefix  = "*"
    }
  security_rule {  
      name  = "icmp"
      priority  = 140
      direction = "Inbound"
      access  = "Allow"
      protocol  = "Icmp"
      source_port_range = "*"
      destination_port_range  = "*"
      source_address_prefix = "*"
      destination_address_prefix  = "*"
    }
}
resource "azurerm_subnet_network_security_group_association" "dev_front_nsg_subnet" {
  subnet_id = azurerm_subnet.dev_front_subnet.id
  network_security_group_id = azurerm_network_security_group.dev_front_nsg.id
}

# Business tier
# Create Subnet
resource "azurerm_subnet" "dev_business_subnet" {
  name  = "${var.prefix}-business-subnet"
  resource_group_name = azurerm_resource_group.web_rg.name
  virtual_network_name = azurerm_virtual_network.dev_vnet.name
  address_prefixes = [ "10.0.1.0/24" ] 
}

# Create NSG
resource "azurerm_network_security_group" "dev_business_nsg" {
  name = "${var.prefix}-business-nsg"
  location = azurerm_resource_group.web_rg.location
  resource_group_name = azurerm_resource_group.web_rg.name
  security_rule {
      name  = "SSH"
      priority  = 100
      direction = "Inbound"
      access  = "Allow"
      protocol  = "Tcp"
      source_port_range = "*"
      destination_port_range  = 22
      source_address_prefix = var.src_ip
      destination_address_prefix  = "*"
  }
  security_rule {  
      name  = "http"
      priority  = 120
      direction = "Inbound"
      access  = "Allow"
      protocol  = "Tcp"
      source_port_range = "*"
      destination_port_range  = 80
      source_address_prefix = "*"
      destination_address_prefix  = "*"
    }
  security_rule {  
      name  = "tomcat"
      priority  = 130
      direction = "Inbound"
      access  = "Allow"
      protocol  = "Tcp"
      source_port_range = "*"
      destination_port_range  = 8089
      source_address_prefix = "*"
      destination_address_prefix  = "*"
    }
}
resource "azurerm_subnet_network_security_group_association" "dev_business_nsg_subnet" {
  subnet_id = azurerm_subnet.dev_business_subnet.id
  network_security_group_id = azurerm_network_security_group.dev_business_nsg.id
}