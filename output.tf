<<<<<<< HEAD
=======
data "azurerm_public_ip" "myterraformpublicip" {
    name                = azurerm_public_ip.myterraformpublicip.name
    resource_group_name = azurerm_linux_virtual_machine.myterraformvm.resource_group_name
}

output "public_ip_address" {
    value = data.azurerm_public_ip.myterraformpublicip.ip_address
}

output "fqdn" {
    value = data.azurerm_public_ip.myterraformpublicip.fqdn
}

#bastion
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


output "username" { 
    value = var.web-linux-admin-username
}

output "tls_private_key" { 
    value = "${tls_private_key.example_ssh.private_key_pem}" 
}
>>>>>>> 02ad45269351ab4d8c19e383b6041b2ce725b471
