module "bastion" {
  source = "github.com/metall773/e-terraform-modules.git//modules/bastion"
    app_name                         = var.app_name
    environment                      = var.environment
    network-vnet                     = module.network.network-vnet.name
    network-rg                       = azurerm_resource_group.terraformgroup.name
    batstion_subnet_cidr             = "10.16.2.0/24"
    # posible locations listed here https://docs.microsoft.com/en-us/azure/bastion/bastion-overview#faq
    bastion_location                 = "north europe"
}

module "win1-vm" {
  source = "github.com/metall773/e-terraform-modules.git//modules/win-vm"
    app_name                         = var.app_name
    environment                      = var.environment
    network-subnet                   = module.network.network-subnet.id
    win-vm-size                      = "Standard_B2s"
    win-admin-username               = "lee"
    storage_account_type             = "Standard_LRS"
    managed_disk_size_gb             = [53, 5]
    win-vm-prefix                    = "win1"
    location                         = "north europe"
    azurerm_storage_account_tier     = "Standard"
    azurerm_account_replication_type = "LRS"
    azurerm_storage_share_quota      = "48"
    firewall_tcp_ports               = [3389, 80, 443, 8433]
    firewall_udp_ports               = [3389]
    enable_automatic_updates         = true
    shared_disk_name                 = module.shared-storage.fileshare4all.name
    shared_disk_storage_account      = module.shared-storage.storageaccount4all
    choco_list                       = "7zip putty notepadplusplus git googlechrome ublockorigin-chrome chocolateygui"
}