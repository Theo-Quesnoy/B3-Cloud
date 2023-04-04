terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg-node" {
  name     = "nodes"
  location = "eastus"
}

resource "azurerm_virtual_network" "vn-node" {
  name                = "nodes"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg-node.location
  resource_group_name = azurerm_resource_group.rg-node.name
}

resource "azurerm_subnet" "s-node1" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg-node.name
  virtual_network_name = azurerm_virtual_network.vn-node.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_subnet" "s-node2" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg-node.name
  virtual_network_name = azurerm_virtual_network.vn-node.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_public_ip" "pb-node1" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = azurerm_resource_group.rg-node.name
  location            = azurerm_resource_group.rg-node.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic-node1" {
  name                = "nic-node1"
  location            = azurerm_resource_group.rg-node.location
  resource_group_name = azurerm_resource_group.rg-node.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.s-node1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pb-node1.id
  }
}

resource "azurerm_network_interface" "nic-node2" {
  name                = "nic-node2"
  location            = azurerm_resource_group.rg-node.location
  resource_group_name = azurerm_resource_group.rg-node.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.s-node2.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm-node1" {
  name                = "node1"
  resource_group_name = azurerm_resource_group.rg-node.name
  location            = azurerm_resource_group.rg-node.location
  size                = "Standard_B1s"
  admin_username      = "theo"
  network_interface_ids = [
    azurerm_network_interface.nic-node1.id,
  ]

  admin_ssh_key {
    username   = "theo"
    public_key = file("C:/Users/theoq/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "vm-node2" {
  name                = "node2"
  resource_group_name = azurerm_resource_group.rg-node.name
  location            = azurerm_resource_group.rg-node.location
  size                = "Standard_B1s"
  admin_username      = "theo"
  network_interface_ids = [
    azurerm_network_interface.nic-node2.id,
  ]

  admin_ssh_key {
    username   = "theo"
    public_key = file("C:/Users/theoq/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Debian"
    offer     = "Debian-10"
    sku       = "10"
    version   = "latest"
  }
}