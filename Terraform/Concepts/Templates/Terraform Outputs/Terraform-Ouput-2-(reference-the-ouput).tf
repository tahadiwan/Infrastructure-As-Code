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

#specify where to get the tfstate file that contains the outputs
data "terraform_remote_state" "terraformdemo" {    
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-terraformstate"
    storage_account_name = "terraformstorage"
    container_name       = "terraformdemo"
    key                  = "terraform2.tfstate"
  }
}

resource "azurerm_subnet" "app_subnet" {
  name                 = "Subnet1"
  resource_group_name  = data.terraform_remote_state.terraformdemo.outputs.rg_name   # reference the rg output
  virtual_network_name = data.terraform_remote_state.terraformdemo.outputs.vnet_name # reference the vnet name output
  address_prefixes     = ["10.0.2.0/24"]
}