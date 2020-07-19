# Create public IPs
resource "azurerm_public_ip" "myterraformpublicip" {
  name                = "${local.vm_name}-PublicIP"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Dynamic"
  domain_name_label   = local.vm_name

  tags = {
        application = var.app_name
        environment = var.environment
        vm-name     = local.vm_name
  }
}

# Create network interface
resource "azurerm_network_interface" "myterraformnic" {
    name                = "${local.vm_name}-NIC"
    location            = azurerm_resource_group.myterraformgroup.location
    resource_group_name = azurerm_resource_group.myterraformgroup.name

    ip_configuration {
        name                          = "${local.vm_name}-NicConfiguration"
        subnet_id                     = var.network-subnet
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
    }

    tags = {
        application = var.app_name
        environment = var.environment
        vm-name     = local.vm_name
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.myterraformnic.id
  network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}