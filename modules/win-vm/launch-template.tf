locals {
  share_host  = azurerm_storage_account.mystorageaccount-files.primary_file_host
  share_name  = azurerm_storage_share.myfileshare.name
  share_login = azurerm_storage_account.mystorageaccount-files.name
  share_pass  = azurerm_storage_account.mystorageaccount-files.primary_access_key
  init_params = "-share_host ${local.share_host} -share_name ${local.share_name} -share_login ${local.share_login} -share_pass ${local.share_pass}"
}

#https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-windows#troubleshoot-and-support
# log file - C:\WindowsAzure\Logs\Plugins\Microsoft.Compute.CustomScriptExtension
resource "azurerm_virtual_machine_extension" "disk-windows-vm-extension" {
  name                 = "win-${random_id.randomId.hex}-vm-extension"
  virtual_machine_id   = azurerm_windows_virtual_machine.win_virtual_machine.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = <<SETTINGS
    {
      "fileUris": ["https://raw.githubusercontent.com/metall773/e-keys/master/scripts/windows-init.ps1"]
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "powershell.exe -Command \"./windows-init.ps1 ${local.init_params} ; exit 0;\" "
    }
PROTECTED_SETTINGS

  depends_on = [
      azurerm_virtual_machine_data_disk_attachment.win-vm-managed_disk,
      azurerm_storage_share.myfileshare
    ]

  tags = {
    application = var.app_name
    environment = var.environment
    vm-name     = local.vm_name
  }
}