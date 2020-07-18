web-linux-vm-size = "Standard_B2s"
web-linux-admin-username = "azureuser"
storage_account_type = "Standard_LRS"
managed_disk_size_gb = "5"
web-linux-vm-prefix = "test"
location = "north europe"
azurerm_storage_account_tier = "Standard"
azurerm_account_replication_type = "LRS"
azurerm_storage_share_quota = "50"

#vm network variables
network-vnet-cidr = "10.0.0.0/22" #10.0.0.0 - 10.0.3.255
network-subnet-cidr = ["10.0.1.0/24"]

#bastion variables
#batstion_subnet_cidr = "10.0.2.0/24"
# posible locations listed here https://docs.microsoft.com/en-us/azure/bastion/bastion-overview#faq
#bastion_location = "north europe"
