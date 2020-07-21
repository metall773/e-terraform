/*data "azurerm_public_ip" "public-ip" {
    name                = azurerm_public_ip.public-ip[0].name
    resource_group_name = azurerm_linux_virtual_machine.myterraformvm.resource_group_name
}

output "public_ip_address" {
    value = data.azurerm_public_ip.public-ip.ip_address
}

output "fqdn" {
    value = data.azurerm_public_ip.public-ip.fqdn
}

output "username" { 
    value = var.web-linux-admin-username
}

output "tls_private_key" { 
    value = tls_private_key.example_ssh.private_key_pem
} */