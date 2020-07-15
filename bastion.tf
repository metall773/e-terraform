locals {
    bastion_name = "${var.environment}-bastion"
}

resource "azurerm_resource_group" "bastion" {
    name     = "${var.environment}-bastion-ResourceGroup"
    location = var.location
}

# Create public IPs
resource "azurerm_public_ip" "bastionpublicip" {
    name                = "${local.bastion_name}-PublicIP"
    location            = azurerm_resource_group.bastion.location
    resource_group_name = azurerm_resource_group.bastion.name
    allocation_method   = "Dynamic"
    domain_name_label   = local.bastion_name

    tags = {
        application = var.app_name
        environment = var.environment
        vm-name     = local.bastion_name
    }
}

resource "azurerm_bastion_host" "bastion" {
    name                = "${var.environment}-bastion"
    location            = azurerm_resource_group.bastion.location
    resource_group_name = azurerm_resource_group.bastion.name

    ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.network-subnet.id
    public_ip_address_id = azurerm_public_ip.bastionpublicip.id
    }
}