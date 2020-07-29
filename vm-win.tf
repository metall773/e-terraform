module "win-vm1" {
  source = "github.com/metall773/e-terraform-modules.git//modules/win-vm"
    app_name                         = var.app_name
    environment                      = var.environment
    network-subnet                   = module.network.network-subnet.id
    win-vm-size                      = "Standard_B4ms"
    win-admin-username               = "lee"
    storage_account_type             = "Standard_LRS"
    managed_disk_size_gb             = [150]
    win-vm-prefix                    = "term"
    location                         = "north europe"
    azurerm_storage_account_tier     = "Standard"
    azurerm_account_replication_type = "LRS"
    azurerm_storage_share_quota      = "100"
    firewall_tcp_ports               = [3389]
    firewall_udp_ports               = [3389]
    enable_automatic_updates         = true
    shared_disk_name                 = module.shared-storage.fileshare4all.name
    shared_disk_storage_account      = module.shared-storage.storageaccount4all
    choco_list                       = "7zip putty notepadplusplus googlechrome ublockorigin-chrome chocolateygui"
}

module "win-vm2" {
  source = "github.com/metall773/e-terraform-modules.git//modules/win-vm"
    app_name                         = var.app_name
    environment                      = var.environment
    network-subnet                   = module.network.network-subnet.id
    win-vm-size                      = "Standard_B4ms"
    win-admin-username               = "lee"
    storage_account_type             = "Standard_LRS"
    managed_disk_size_gb             = [150]
    win-vm-prefix                    = "1c"
    location                         = "north europe"
    azurerm_storage_account_tier     = "Standard"
    azurerm_account_replication_type = "LRS"
    azurerm_storage_share_quota      = "100"
    firewall_tcp_ports               = [3389]
    firewall_udp_ports               = [3389]
    enable_automatic_updates         = true
    shared_disk_name                 = module.shared-storage.fileshare4all.name
    shared_disk_storage_account      = module.shared-storage.storageaccount4all
    choco_list                       = "7zip putty notepadplusplus git googlechrome ublockorigin-chrome chocolateygui"
}