output "public_ip_address" {
    value = data.azurerm_public_ip.myterraformpublicip.ip_address
}

output "username" { 
    value = var.web-linux-admin-username
}

output "tls_private_key" { 
    value = "${tls_private_key.example_ssh.private_key_pem}" 
}