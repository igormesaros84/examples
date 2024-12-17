
provider "azurerm" {
  features {}
}

resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "azurerm_resource_group" "ghostenvrg" {
    name     = "${join("-", [var.resource_group.name, random_integer.random.result])}"
    location = var.resource_group.location
}


module "vpn" {
    source = "./modules/virtual_network"

    resource_group = azurerm_resource_group.ghostenvrg
    vnet_name = "vnet"
    vnet_address_space = ["22.0.0.0/16"]
    gateway_subnet_address_prefix = "22.0.1.0/24"
    main_subnet_address_prefixes = ["22.0.2.0/24"]
}