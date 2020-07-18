bastion
data "azurerm_public_ip" "bastion-public-ip" {
    name                = azurerm_public_ip.bastion-public-ip.name
    resource_group_name = azurerm_bastion_host.bastion-host.resource_group_name
}

output "public_ip_address_bastion" {
    value = data.azurerm_public_ip.bastion-public-ip.ip_address
}

output "fqdn_bastion" {
    value = data.azurerm_public_ip.bastion-public-ip.fqdn
}
