terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.73.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "....."
  client_id       = "...."
  client_secret   = "...."
  tenant_id       = "..."
  features {}
}

resource "azurerm_resource_group" "Terraform_test"{
  name="Terraform_test" 
  location="Central India"
}


resource "azurerm_storage_account" "storage_account_test" {
  name                     = "terraformstorage"
  resource_group_name      = "Terraform_test"
  location                 = "Central India"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
