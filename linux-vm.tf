module "centos7-vm" {
  source = "./modules/centos7-vm"
    app_name                         = "${var.app_name}"
    environment                      = "${var.environment}"
    network-subnet                   = azurerm_subnet.network-subnet.id
    web-linux-vm-size                = "Standard_B2s"
    web-linux-admin-username         = "azureuser"
    storage_account_type             = "Standard_LRS"
    managed_disk_size_gb             = "5"
    web-linux-vm-prefix              = "test"
    location                         = "north europe"
    azurerm_storage_account_tier     = "Standard"
    azurerm_account_replication_type = "LRS"
    azurerm_storage_share_quota      = "50"
    firewall_tcp_ports               = [22, 80, 443, 8433]
}

module "centos7-vm2" {
  source = "./modules/centos7-vm"
    app_name                         = "${var.app_name}"
    environment                      = "${var.environment}"
    network-subnet                   = azurerm_subnet.network-subnet.id
    web-linux-vm-prefix              = "test2"
    firewall_tcp_ports               = [22, 80, 443]
    firewall_udp_ports               = [53, 1002, 2005]
    install_bitrix                   = "no"
}
