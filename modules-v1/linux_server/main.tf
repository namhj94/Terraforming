data "azurerm_resource_group" "vm" {
  name = var.resource_group_name
}

resource "azurerm_network_interface" "vm" {
  name                = var.nic_name
  resource_group_name = data.azurerm_resource_group.vm.name
  location            = coalesce(var.location, data.azurerm_resource_group.vm.location)

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = var.public_ip_address_id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.hostname
  resource_group_name = data.azurerm_resource_group.vm.name
  location            = coalesce(var.location, data.azurerm_resource_group.vm.location)
  size                = var.size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.vm.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_sku
  }

  source_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = var.tag
  }

  disable_password_authentication = false
  #boot_diagnostics
  #admin_ssh_key
}