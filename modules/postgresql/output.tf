output "fqdn" {
    value = azurerm_postgresql_server.postgresql-db.fqdn
}

output "username" {
    value = "${azurerm_postgresql_server.postgresql-db.administrator_login}@${azurerm_postgresql_server.postgresql-db.name}"
}