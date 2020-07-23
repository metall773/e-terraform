output "fqdn" {
    value = azurerm_mysql_server.mysql-db.fqdn
}

output "username" {
    value = "${azurerm_mysql_server.mysql-db.administrator_login}@${azurerm_mysql_server.mysql-db.name}"
}