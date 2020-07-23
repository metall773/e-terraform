resource "azurerm_network_interface" "win_network_interface" {
  name                = "${local.vm_name}-NIC"
  location            = azurerm_resource_group.win-terraform-group.location
  resource_group_name = azurerm_resource_group.win-terraform-group.name

  ip_configuration {
    name                          = "${local.vm_name}-PrivateIP"
    subnet_id                     = var.network-subnet
    private_ip_address_allocation = "Dynamic"
  }

  tags = {
    application = var.app_name
    environment = var.environment
    vm-name     = local.vm_name
  }
}