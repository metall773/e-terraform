# Create Network Security Group and rule
resource "azurerm_network_security_group" "myterraformnsg" {
  name                = "${local.vm_name}-NetworkSecurityGroup"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  security_rule {
    name                       = "${local.vm_name}-SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
        application = var.app_name
        environment = var.environment
        vm-name     = local.vm_name
  }
}

resource "azurerm_network_security_rule" "allow_tcp_80_rule" {
  name                        = "${local.vm_name}-allow_HTTP"
  priority                    = 1000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.myterraformgroup.name
  network_security_group_name = azurerm_network_security_group.myterraformnsg.name
}

resource "azurerm_network_security_rule" "allow_tcp_443_rule" {
  name                        = "${local.vm_name}-allow_HTTPS"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.myterraformgroup.name
  network_security_group_name = azurerm_network_security_group.myterraformnsg.name
}

resource "azurerm_network_security_rule" "allow_tcp_8443_rule" {
  name                        = "${local.vm_name}-allow_HTTPS_8443"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.myterraformgroup.name
  network_security_group_name = azurerm_network_security_group.myterraformnsg.name
}