module "centos7-vm" {
  source = "modules/centos7-vm"

    web-linux-vm-size                = "Standard_B2s"
    web-linux-admin-username         = "azureuser"
    storage_account_type             = "Standard_LRS"
    managed_disk_size_gb             = "5"
    web-linux-vm-prefix              = "test"
    location                         = "north europe"
    azurerm_storage_account_tier     = "Standard"
    azurerm_account_replication_type = "LRS"
    azurerm_storage_share_quota      = "50"
}