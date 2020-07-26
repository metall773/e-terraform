module "centos7-vm" {
  source = "./modules/centos7-vm"
    app_name                         = var.app_name
    environment                      = var.environment
    network-subnet                   = azurerm_subnet.network-subnet.id
    web-linux-vm-size                = "Standard_B1ms"
    web-linux-admin-username         = "azureuser"
    storage_account_type             = "Standard_LRS"
    managed_disk_size_gb             = "5"
    web-linux-vm-prefix              = "test"
    location                         = "north europe"
    azurerm_storage_account_tier     = "Standard"
    azurerm_account_replication_type = "LRS"
    azurerm_storage_share_quota      = "50"
    firewall_tcp_ports               = [22, 80, 443, 8433]
    shared_disk_name                 = azurerm_storage_share.fileshare4all.name
    shared_disk_storage_account      = azurerm_storage_account.storageaccount4all
}

module "centos7-vm2" {
  source = "./modules/centos7-vm"
    app_name                         = var.app_name
    environment                      = var.environment
    network-subnet                   = azurerm_subnet.network-subnet.id
    web-linux-vm-prefix              = "mouse"
    firewall_tcp_ports               = [22, 80, 443]
    firewall_udp_ports               = [53, 1002, 2005]
    install_bitrix                   = "no"
    web-linux-admin-username         = "lee"
    managed_disk_mount_point         = "/mnt/data"
    #enable_extenalIP                 = false
    shared_disk_name                 = azurerm_storage_share.fileshare4all.name
    shared_disk_storage_account      = azurerm_storage_account.storageaccount4all
}