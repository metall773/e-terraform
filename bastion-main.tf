#https://docs.microsoft.com/en-us/azure/bastion/bastion-overview
locals {
    bastion_name = "${var.environment}-bastion"
}

resource "azurerm_resource_group" "bastion-ResourceGroup" {
    name     = "${var.environment}-bastion-ResourceGroup"
    location = var.bastion_location
}

# Create Bastion public IP
resource "azurerm_public_ip" "bastion-public-ip" {
    name                = "${local.bastion_name}-PublicIP"
    location            = azurerm_resource_group.bastion-ResourceGroup.location
    resource_group_name = azurerm_resource_group.bastion-ResourceGroup.name
    allocation_method   = "Static"
    sku                 = "Standard"
    domain_name_label   = local.bastion_name

    tags = {
        application = var.app_name
        environment = var.environment
        name        = local.bastion_name
    }
}

# Create Bastion network VNET
resource "azurerm_virtual_network" "bastion-network-vnet" {
    name                = "${local.bastion_name}-vnet"
    address_space       = [var.batstion_vnet_cidr]
    resource_group_name = azurerm_resource_group.bastion-ResourceGroup.name
    location            = azurerm_resource_group.bastion-ResourceGroup.location
    tags = {
        application = var.app_name
        environment = var.environment
    }
}

# Create Bastion subnet for Network
resource "azurerm_subnet" "azure-bastion-subnet" {
    name                 = "AzureBastionSubnet"
    address_prefixes     = [var.batstion_subnet_cidr]
    virtual_network_name = azurerm_virtual_network.bastion-network-vnet.name
    resource_group_name  = azurerm_resource_group.bastion-ResourceGroup.name
}

resource "azurerm_bastion_host" "bastion-host" {
    name                = local.bastion_name
    location            = azurerm_resource_group.bastion-ResourceGroup.location
    resource_group_name = azurerm_resource_group.bastion-ResourceGroup.name

    ip_configuration {
        name                 = "configuration"
        subnet_id            = azurerm_subnet.azure-bastion-subnet.id
        public_ip_address_id = azurerm_public_ip.bastion-public-ip.id
    }
}