data "azurerm_resource_group" "nsg" {
  name = var.resource_group_name
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  resource_group_name = data.azurerm_resource_group.nsg.name
  location            = coalesce(var.location, data.azurerm_resource_group.nsg.location)

  security_rule {
    name                       = var.rule_name
    priority                   = var.priority
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = var.destination_port_range
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg_subnet" {
  subnet_id                 = var.subnet_id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

// resource "azurerm_network_interface_security_group_association" "nsg_nic" {
//   network_interface_id      = var.nic_id
//   network_security_group_id = azurerm_network_security_group.nsg.id
// }