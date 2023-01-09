terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.40.0"
    }
  }
   backend "azurerm" {
    resource_group_name  = "rg-terraformstate"
    storage_account_name = "terraformstorage"
    container_name       = "terraformdemo"
    key                  = "terraform.tfstate"      #### this can be named anything ####
  }
}
provider "azurerm" {
  features {}
}


# create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-terraexample"
  location = "westus2"
}


#create a virtual network
resource "azurerm_virtual_network" "vnet1" {
  name                = "vnet1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location #### this is how you reference other objects ####
  resource_group_name = azurerm_resource_group.rg.name
}


#output resource group name
output "rg_name" {
  description = "resource group"
  value = azurerm_resource_group.rg.name    ## value of the resource to use ouput
}


#output virtual network name
output "vnet_name" {
  description = "virtual network"
  value = azurerm_virtual_network.vnet1.name
}