terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.40.0"
    }
  }
}
provider "azurerm" {
  features {}
}

variable "subnet_vnet1" {
  description = "Map of Azure VNET subnet configuration"
  type        = map(any)
  default = {
    Vnet1 = {
      name                 = "vnet1"
      address_prefixes     = ["10.1.0.0/16"]
      subnets = {
        name = "Subnet1"
        subnet_address_prefix = "10.2.1.0/24"
      }
    },
    Vnet2 = {
      name                 = "Vnet2"
      address_prefixes     = ["10.2.0.0/16"]
    }
  }
}

variable "vnets_foreach" {
  type = map(any)
  default = {
    vnet1 = {
      name                 = "app_subnet"
      address_prefixes     = ["10.1.0.0/16"] 
      subnets = {
        sub_name = "subnet1"
        sub_address_prefixes     = ["10.1.1.0/24"]
      }
    }
    vnet2 = {
      name                 = "app_subnet"
      address_prefixes     = ["10.2.0.0/16"] 
      subnets = {
        sub_name = "subnet1"
        sub_address_prefixes     = ["10.2.1.0/24"]
      }
    }
  }
}

resource "azurerm_virtual_network" "Vnet1" {
  for_each = var.vnets_foreach
  name                = each.value["name"]
  location            = "westus"
  resource_group_name = "ForEach-RG"
  address_space       = each.value["address_prefixes"]
  subnet {
    name           = each.value[sub_address_prefix]
    address_prefix = "10.0.1.0/24"
  }
}


resource "azurerm_subnet" "subnets" {
  for_each = var.subnet

  name                 = each.value["name"]                       # reference each subnet in the map
  resource_group_name  = azurerm_virtual_network.Vnet1.resource_group_name    # reference the vnets' RG
  virtual_network_name = azurerm_virtual_network.Vnet1.name       # reference the vnets name
  address_prefixes     = each.value["address_prefixes"]           # reference each subnets AddressPrefix
  depends_on           = [azurerm_virtual_network.Vnet1]        #reference the vnets name 
}

