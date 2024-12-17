variable "resource_group" {
  type = object({
      name = string
      location = string
  })
  description = "Resource group name and location"
}

variable "vnet_name" {
    type = string
    description = "Vnet Name"
    nullable = false
}

variable "vnet_address_space" {
    type = list(string)
    description = "Vnet address space, contains a list of addresses"
}

variable "gateway_subnet_address_prefix" {
    type = string
    description = "Gateway Subnet address prefix"
}

variable "main_subnet_address_prefixes" {
    type = list(string)
    description = "Main subnet address prefixes"
}