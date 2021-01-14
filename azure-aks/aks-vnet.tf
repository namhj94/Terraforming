resource "azurerm_resource_group" "terraform_rg" {
  name     = "terraform-rg"
  location = "koreacentral"
}
module "network" {
  source              = "Azure/network/azurerm"
  version             = "3.2.1"
  vnet_name           = "aks-vnet"
  resource_group_name = azurerm_resource_group.terraform_rg.name
  address_space       = "10.0.0.0/8"
  subnet_prefixes     = ["10.240.0.0/16", "10.1.0.0/16"]
  subnet_names        = ["subnet00", "subnet01"]
  depends_on          = [azurerm_resource_group.terraform_rg]
}

# resource "azurerm_virtual_network" "aks_vnet" {
#   name = "aks-vnet"
#   location = azurerm_resource_group.terraform_rg.location
#   resource_group_name = azurerm_resource_group.terraform_rg.name
#   address_space = [ "10.0.0.0/8" ]
# }
# resource "azurerm_subnet" "aks_vnet_subnet" {
#   name = "aks-vnet-subnet"
#   resource_group_name = azurerm_resource_group.terraform_rg.name
#   virtual_network_name = azurerm_virtual_network.aks_vnet.name
#   address_prefixes = [ "10.240.0.0/16" ]
# }
