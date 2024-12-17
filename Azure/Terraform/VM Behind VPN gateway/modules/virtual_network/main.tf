resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  address_space       = var.vnet_address_space
  dns_servers         = []

  subnet {
    name           = "GatewaySubnet"
    address_prefix = var.gateway_subnet_address_prefix
  }
}

resource "azurerm_subnet" "subnet" {
  name                 = "main-subnet"
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.main_subnet_address_prefixes
}