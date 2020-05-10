provider "azurerm" {
  version = "=2.8.0"
  features {}
  subscription_id = var.azure-subscription-id
  client_id       = var.azure-client-id
  client_secret   = var.azure-client-secret 
  tenant_id       = var.azure-tenant-id
}

resource "azurerm_resource_group" "example" {
  name     = "KthDemoRG"
  location = "East US"
}

resource "azurerm_virtual_network" "example-1" {
  name                = "HelalVN1"
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]
  location            = "East US"

  subnet {
    name           = "HelalSubnet1"
    address_prefix = "10.0.0.0/24"
  }
}

resource "azurerm_virtual_network" "example-2" {
  name                = "AdamVN1"
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.1.0.0/16"]
  location            = "East US"

  subnet {
    name           = "AdamSubnet1"
    address_prefix = "10.1.0.0/24"
  }
}

resource "azurerm_virtual_network_peering" "example-1" {
  name                      = "helalVN1-adamVN1"
  resource_group_name       = azurerm_resource_group.example.name
  virtual_network_name      = azurerm_virtual_network.example-1.name
  remote_virtual_network_id = azurerm_virtual_network.example-2.id
}

resource "azurerm_virtual_network_peering" "example-2" {
  name                      = "adamVN1-helalVN1"
  resource_group_name       = azurerm_resource_group.example.name
  virtual_network_name      = azurerm_virtual_network.example-2.name
  remote_virtual_network_id = azurerm_virtual_network.example-1.id
}

resource "azurerm_virtual_machine" "example" {
  name                  = "VM1"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  vm_size               = "Standard_D2s_v3"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  os_profile {
    admin_username = "Helal"
    admin_password = "Ab1234567890"
  }
}
