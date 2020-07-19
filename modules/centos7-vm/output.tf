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

output "username" { 
    value = var.web-linux-admin-username
}

output "tls_private_key" { 
    value = tls_private_key.example_ssh.private_key_pem
}