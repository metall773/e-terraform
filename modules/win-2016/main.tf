locals {
  vm_name = "${var.environment}-${var.win-vm-prefix}-vm"
}

resource "azurerm_resource_group" "win-terraform-group" {
  name     = local.vm_name
  location = var.location

  tags = {
        application = var.app_name
        environment = var.environment
        vm-name     = local.vm_name
  }
}

resource "azurerm_network_interface" "win_network_interface" {
  name                = "example-nic"
  location            = azurerm_resource_group.win-terraform-group.location
  resource_group_name = azurerm_resource_group.win-terraform-group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.network-subnet
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "win_virtual_machine {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.win-terraform-group.name
  location            = azurerm_resource_group.win-terraform-group.location
  size                = "Standard_F2"
  admin_username      = var.win-admin-username
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.storage_account_type
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}