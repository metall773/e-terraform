module "bastion" {
  source = "./modules/bastion"
    app_name                         = "${var.app_name}"
    environment                      = "${var.environment}"
    network-vnet                     = azurerm_virtual_network.network-vnet.name
    network-rg                       = azurerm_resource_group.network-rg.name
    batstion_subnet_cidr             = "10.0.2.0/24"
    # posible locations listed here https://docs.microsoft.com/en-us/azure/bastion/bastion-overview#faq
    bastion_location                 = "north europe"
}

module "win1-vm" {
  source = "./modules/win2016-vm"
    app_name                         = "${var.app_name}"
    environment                      = "${var.environment}"
    network-subnet                   = azurerm_subnet.network-subnet.id
    win-vm-size                      = "Standard_B2s"
    win-admin-username               = "lee"
    storage_account_type             = "Standard_LRS"
    managed_disk_size_gb             = "53"
    win-vm-prefix                    = "win1"
    location                         = "north europe"
    azurerm_storage_account_tier     = "Standard"
    azurerm_account_replication_type = "LRS"
    azurerm_storage_share_quota      = "48"
    firewall_tcp_ports               = [3389, 80, 443, 8433]
    firewall_udp_ports               = [3389]
    enable_automatic_updates         = true
}