# Data template Bash bootstrapping file
data "template_file" "linux-vm-cloud-init" {
    template = file("azure-centos7-user-data.tpl")
    vars = {
        storage_account= "${azurerm_storage_account.mystorageaccount-files.name}"
        share_pass     = "${azurerm_storage_account.mystorageaccount-files.primary_access_key}"
        share_name     = "${azurerm_storage_share.myfileshare.name}"
    }
}