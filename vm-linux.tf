module "centos7-vm1" {
  source = "github.com/metall773/e-terraform-modules.git//modules/centos7-vm"
    app_name                         = var.app_name
    environment                      = var.environment
    network-subnet                   = module.network.network-subnet.id
    web-linux-vm-size                = "Standard_B2ms"
    web-linux-admin-username         = "azureuser"
    storage_account_type             = "Standard_LRS"
    managed_disk_size_gb             = "40"
    web-linux-vm-prefix              = "crm"
    location                         = "north europe"
    azurerm_storage_account_tier     = "Standard"
    azurerm_account_replication_type = "LRS"
    azurerm_storage_share_quota      = "50"
    firewall_tcp_ports               = [22, 80, 443]
    shared_disk_name                 = module.shared-storage.fileshare4all.name
    shared_disk_storage_account      = module.shared-storage.storageaccount4all
}

module "centos7-vm2" {
  source = "github.com/metall773/e-terraform-modules.git//modules/centos7-vm"
    app_name                         = var.app_name
    environment                      = var.environment
    network-subnet                   = module.network.network-subnet.id
    web-linux-vm-size                = "Standard_B2ms"
    web-linux-admin-username         = "azureuser"
    storage_account_type             = "Standard_LRS"
    managed_disk_size_gb             = "40"
    web-linux-vm-prefix              = "multibonus"
    location                         = "north europe"
    azurerm_storage_account_tier     = "Standard"
    azurerm_account_replication_type = "LRS"
    azurerm_storage_share_quota      = "50"
    firewall_tcp_ports               = [22, 80, 443]
    shared_disk_name                 = module.shared-storage.fileshare4all.name
    shared_disk_storage_account      = module.shared-storage.storageaccount4all
}

module "centos7-vm3" {
  source = "github.com/metall773/e-terraform-modules.git//modules/centos7-vm"
    app_name                         = var.app_name
    environment                      = var.environment
    network-subnet                   = module.network.network-subnet.id
    web-linux-vm-size                = "Standard_B2ms"
    web-linux-admin-username         = "azureuser"
    storage_account_type             = "Standard_LRS"
    managed_disk_size_gb             = "40"
    web-linux-vm-prefix              = "urozhai"
    location                         = "north europe"
    azurerm_storage_account_tier     = "Standard"
    azurerm_account_replication_type = "LRS"
    azurerm_storage_share_quota      = "50"
    firewall_tcp_ports               = [22, 80, 443]
    shared_disk_name                 = module.shared-storage.fileshare4all.name
    shared_disk_storage_account      = module.shared-storage.storageaccount4all
}

module "centos7-vm4" {
  source = "github.com/metall773/e-terraform-modules.git//modules/centos7-vm"
    app_name                         = var.app_name
    environment                      = var.environment
    network-subnet                   = module.network.network-subnet.id
    web-linux-vm-size                = "Standard_B2s"
    web-linux-admin-username         = "azureuser"
    storage_account_type             = "Standard_LRS"
    managed_disk_size_gb             = "40"
    web-linux-vm-prefix              = "catalog"
    location                         = "north europe"
    azurerm_storage_account_tier     = "Standard"
    azurerm_account_replication_type = "LRS"
    azurerm_storage_share_quota      = "50"
    firewall_tcp_ports               = [22, 80, 443]
    shared_disk_name                 = module.shared-storage.fileshare4all.name
    shared_disk_storage_account      = module.shared-storage.storageaccount4all
}

module "centos7-vm5" {
  source = "github.com/metall773/e-terraform-modules.git//modules/centos7-vm"
    app_name                         = var.app_name
    environment                      = var.environment
    network-subnet                   = module.network.network-subnet.id
    web-linux-vm-size                = "Standard_B2s"
    web-linux-admin-username         = "azureuser"
    storage_account_type             = "Standard_LRS"
    managed_disk_size_gb             = "40"
    web-linux-vm-prefix              = "catalog-marvel"
    location                         = "north europe"
    azurerm_storage_account_tier     = "Standard"
    azurerm_account_replication_type = "LRS"
    azurerm_storage_share_quota      = "50"
    firewall_tcp_ports               = [22, 80, 443]
    shared_disk_name                 = module.shared-storage.fileshare4all.name
    shared_disk_storage_account      = module.shared-storage.storageaccount4all
}

module "centos7-vm6" {
  source = "github.com/metall773/e-terraform-modules.git//modules/centos7-vm"
    app_name                         = var.app_name
    environment                      = var.environment
    network-subnet                   = module.network.network-subnet.id
    web-linux-vm-size                = "Standard_B2s"
    web-linux-admin-username         = "azureuser"
    storage_account_type             = "Standard_LRS"
    managed_disk_size_gb             = "40"
    web-linux-vm-prefix              = "homecredit"
    location                         = "north europe"
    azurerm_storage_account_tier     = "Standard"
    azurerm_account_replication_type = "LRS"
    azurerm_storage_share_quota      = "50"
    firewall_tcp_ports               = [22, 80, 443]
    shared_disk_name                 = module.shared-storage.fileshare4all.name
    shared_disk_storage_account      = module.shared-storage.storageaccount4all
}

module "centos7-vm7" {
  source = "github.com/metall773/e-terraform-modules.git//modules/centos7-vm"
    app_name                         = var.app_name
    environment                      = var.environment
    network-subnet                   = module.network.network-subnet.id
    web-linux-vm-size                = "Standard_B2s"
    web-linux-admin-username         = "azureuser"
    storage_account_type             = "Standard_LRS"
    managed_disk_size_gb             = "40"
    web-linux-vm-prefix              = "otpbank"
    location                         = "north europe"
    azurerm_storage_account_tier     = "Standard"
    azurerm_account_replication_type = "LRS"
    azurerm_storage_share_quota      = "50"
    firewall_tcp_ports               = [22, 80, 443]
    shared_disk_name                 = module.shared-storage.fileshare4all.name
    shared_disk_storage_account      = module.shared-storage.storageaccount4all
}

module "centos7-vm8" {
  source = "github.com/metall773/e-terraform-modules.git//modules/centos7-vm"
    app_name                         = var.app_name
    environment                      = var.environment
    network-subnet                   = module.network.network-subnet.id
    web-linux-vm-size                = "Standard_B2s"
    web-linux-admin-username         = "azureuser"
    storage_account_type             = "Standard_LRS"
    managed_disk_size_gb             = "40"
    web-linux-vm-prefix              = "catalog-merlion"
    location                         = "north europe"
    azurerm_storage_account_tier     = "Standard"
    azurerm_account_replication_type = "LRS"
    azurerm_storage_share_quota      = "50"
    firewall_tcp_ports               = [22, 80, 443]
    shared_disk_name                 = module.shared-storage.fileshare4all.name
    shared_disk_storage_account      = module.shared-storage.storageaccount4all
}