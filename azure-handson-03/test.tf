# Create Resource Group
resource "azurerm_resource_group" "rg" {
  name = "handson-03"
  location = var.location
}

# Create Vnet
resource "azurerm_virtual_network" "vnet00" {
  name                = "vnet00"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/8"]
}

# Create Subnet00 and Subnet01
resource "azurerm_subnet" "subnet00" {
  name                 = "subnet00"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet00.name
  address_prefixes     = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "subnet01" {
  name                 = "subnet01"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet00.name
  address_prefixes     = ["10.2.0.0/16"]
}

# Create nsg00
resource "azurerm_network_security_group" "nsg00" {
  name                = "nsg00"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  security_rule {
    name                       = "RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = 3389
  }
  security_rule {
    name                       = "HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = 80
  }
  security_rule {
    name                       = "ICMP"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "*"
  }
}
resource "azurerm_network_security_group" "nsg01" {
  name                = "nsg00"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  security_rule {
    name                       = "RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = 3389
  }
  security_rule {
    name                       = "HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = 80
  }
  security_rule {
    name                       = "ICMP"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "*"
  }
  security_rule {
    name                       = "SMB"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_address_prefix      = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
    destination_port_range     = "445"
  }
}


# Associate nsg to subnet
resource "azurerm_subnet_network_security_group_association" "nsg_associate00" {
  subnet_id                 = azurerm_subnet.subnet00.id
  network_security_group_id = azurerm_network_security_group.nsg00.id
}
resource "azurerm_subnet_network_security_group_association" "nsg_associate01" {
  subnet_id                 = azurerm_subnet.subnet01.id
  network_security_group_id = azurerm_network_security_group.nsg01.id
}

# Create Availability Set
resource "azurerm_availability_set" "avset00" {
  name                = "avset00"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_availability_set" "avset01" {
  name                = "avset01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create NIC
resource "azurerm_network_interface" "nic00" {
  name                = "nic00"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal00"
    subnet_id                     = azurerm_subnet.subnet00.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_network_interface" "nic01" {
  name                = "nic01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal01"
    subnet_id                     = azurerm_subnet.subnet00.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_network_interface" "nic02" {
  name                = "nic02"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal02"
    subnet_id                     = azurerm_subnet.subnet01.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_network_interface" "nic03" {
  name                = "nic03"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal03"
    subnet_id                     = azurerm_subnet.subnet01.id
    private_ip_address_allocation = "Dynamic"
  }
}


# Create Windows VM
resource "azurerm_windows_virtual_machine" "wvm00" {
  name                = "wvm00"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_DS1_v2"
  admin_username      = var.username
  admin_password      = var.password
  availability_set_id = azurerm_availability_set.avset00.id
  network_interface_ids = [
    azurerm_network_interface.nic00.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer      = "WindowsServer"
    sku        = "2016-Datacenter"
    version    = "latest"
  }
}
resource "azurerm_windows_virtual_machine" "wvm01" {
  name                = "wvm01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_DS1_v2"
  admin_username      = var.username
  admin_password      = var.password
  availability_set_id = azurerm_availability_set.avset00.id
  network_interface_ids = [
    azurerm_network_interface.nic01.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer      = "WindowsServer"
    sku        = "2016-Datacenter"
    version    = "latest"
  }
}
resource "azurerm_windows_virtual_machine" "wvm02" {
  name                = "wvm02"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_DS1_v2"
  admin_username      = var.username
  admin_password      = var.password
  availability_set_id = azurerm_availability_set.avset01.id
  network_interface_ids = [
    azurerm_network_interface.nic02.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer      = "WindowsServer"
    sku        = "2016-Datacenter"
    version    = "latest"
  }
}
resource "azurerm_windows_virtual_machine" "wvm03" {
  name                = "wvm03"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_DS1_v2"
  admin_username      = var.username
  admin_password      = var.password
  availability_set_id = azurerm_availability_set.avset01.id
  network_interface_ids = [
    azurerm_network_interface.nic03.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer      = "WindowsServer"
    sku        = "2016-Datacenter"
    version    = "latest"
  }
}

# Create External LB

# Create Ext lb pip
resource "azurerm_public_ip" "extlb_pip" {
  name                = "extlb-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

# Create Ext LB
resource "azurerm_lb" "extlb" {
  name                = "extlb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  frontend_ip_configuration {
    name                 = "extlb-fip-config"
    public_ip_address_id = azurerm_public_ip.extlb_pip.id
  }
}

# Create Ext lb backend pool
resource "azurerm_lb_backend_address_pool" "extlb_beppol" {
  name                = "extlb-bepool"
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.extlb.id
}

# Associate wvm00 and wvm01 to Backendpool 
resource "azurerm_network_interface_backend_address_pool_association" "extlb_bepool_association00" {
  network_interface_id    = azurerm_network_interface.nic00.id
  ip_configuration_name   = azurerm_network_interface.nic00.ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.extlb_beppol.id
}
resource "azurerm_network_interface_backend_address_pool_association" "extlb_bepool_association01" {
  network_interface_id    = azurerm_network_interface.nic01.id
  ip_configuration_name   = azurerm_network_interface.nic01.ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.extlb_beppol.id
}
resource "azurerm_lb_probe" "extlb_hp" {
  name                = "extlb-hp"
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.extlb.id
  port                = 80
  protocol            = "http"
  request_path        = "/"
}
resource "azurerm_lb_rule" "extlb_rule" {
  name                           = "extlb-rule"
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.extlb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.extlb.frontend_ip_configuration[0].name
  probe_id                       = azurerm_lb_probe.extlb_hp.id
  backend_address_pool_id        = azurerm_lb_backend_address_pool.extlb_beppol.id
}

# # Create Internal LoadBalancer

resource "azurerm_lb" "intlb" {
  name                = "intlb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  frontend_ip_configuration {
    name                          = "intlb-fip-config"
    subnet_id = azurerm_subnet.subnet01.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create Int lb backend pool
resource "azurerm_lb_backend_address_pool" "intlb_beppol" {
  name                = "intlb-bepool"
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.intlb.id
}

# Associate wvm02 and wvm03 to Backendpool 
resource "azurerm_network_interface_backend_address_pool_association" "intlb_bepool_association00" {
  network_interface_id    = azurerm_network_interface.nic02.id
  ip_configuration_name   = azurerm_network_interface.nic02.ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.intlb_beppol.id
}
resource "azurerm_network_interface_backend_address_pool_association" "intlb_bepool_association01" {
  network_interface_id    = azurerm_network_interface.nic03.id
  ip_configuration_name   = azurerm_network_interface.nic03.ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.intlb_beppol.id
}
resource "azurerm_lb_probe" "intlb_hp" {
  name                = "intlb-hp"
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.intlb.id
  port                = 80
  protocol            = "http"
  request_path        = "/"
}
resource "azurerm_lb_rule" "intlb_rule" {
  name                           = "intlb-rule"
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.intlb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.intlb.frontend_ip_configuration[0].name
  probe_id                       = azurerm_lb_probe.intlb_hp.id
  backend_address_pool_id        = azurerm_lb_backend_address_pool.intlb_beppol.id
}

# Create Bastion Host
resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet00.name
  address_prefixes     = ["10.100.0.0/24"]
}
resource "azurerm_public_ip" "bastion_pip" {
  name                = "bastion-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  depends_on = [azurerm_resource_group.rg]
}

resource "azurerm_bastion_host" "bastion" {
  name                = "AzureBastionHost"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                 = "bastion-ip-config"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
}
# Create FileShare

#Create Storage Account
resource "random_integer" "random" {
  min = 10
  max = 15
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "hjstorageaccount${random_integer.random.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "fshare" {
  name                 = "rgshare"
  storage_account_name = azurerm_storage_account.storage_account.name
  quota                = 50
}