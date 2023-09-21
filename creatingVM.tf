terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.73.0"
    }
  }
}


provider "azurerm" {
  subscription_id = "..."
  client_id       = "..."
  client_secret   = "..."
  tenant_id       = "..."
  features {}
}


locals {
  resource_group="TerraformTest"
  location="Central India"
}

data "azurerm_subnet" "SubnetA" {
  name                 = "SubnetA"
  virtual_network_name = "Test-network"
  resource_group_name  = local.resource_group
}

resource "azurerm_resource_group" "TerraformTest"{
  name=local.resource_group
  location=local.location
}

resource "azurerm_virtual_network" "Test-network" {
  name                = "Test-network"
  location            = local.location
  resource_group_name = local.resource_group
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "SubnetA"
    address_prefix = "10.0.1.0/24"
  }  
}

resource "azurerm_network_interface" "test_interface" {
  name                = "test_interface"
  location            = local.location
  resource_group_name = local.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.SubnetA.id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [
    azurerm_virtual_network.app_network
  ]
}

resource "azurerm_windows_virtual_machine" "First_vm" {
  name                = "First_vm"
  resource_group_name = local.resource_group
  location            = local.location
  size                = "Standard_D2s_v3"
  admin_username      = "sidusr"
  admin_password      = "Siddheshk@1998"
  network_interface_ids = [
    azurerm_network_interface.test_interface.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  depends_on = [
    azurerm_network_interface.test_interface
  ]
}
