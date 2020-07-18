# Azure virtual machine settings #
variable "web-linux-vm-size" {
    type        = string
    description = "Size (SKU) of the virtual machine to create"
    default     = "Standard_B1ls"
}

variable "web-linux-license-type" {
    type        = string
    description = "Specifies the BYOL type for the virtual machine."
    default     = null
}

# Azure virtual machine storage settings #
variable "web-linux-delete-os-disk-on-termination" {
    type        = string
    description = "Should the OS Disk (either the Managed Disk / VHD Blob) be deleted when the Virtual Machine is destroyed?"
    default     = "true"  # Update for your environment
}

variable "web-linux-delete-data-disks-on-termination" {
    description = "Should the Data Disks (either the Managed Disks / VHD Blobs) be deleted when the Virtual Machine is destroyed?"
    type        = string
    default     = "true" # Update for your environment
}

variable "web-linux-vm-image" {
    type        = map(string)
    description = "Virtual machine source image information"
    default     = {
        publisher = "OpenLogic"
        offer     = "CentOS"
        sku       = "7_8"
        version   = "latest"
    }
}

# Azure virtual machine OS profile #
variable "web-linux-admin-username" {
    type        = string
    description = "Username for Virtual Machine administrator account"
    default     = "azureuser"
}

variable "storage_account_type" {
    type        = string
    description = "The storage account type for the Managed Disk"
    default     = "Standard_LRS"
}

variable "managed_disk_size_gb" {
    type        = string
    description = "The size of the Managed Disk in gigabytes"
    default     = "5"
}

variable "web-linux-vm-prefix" {
    default = "example"
}

variable "azurerm_storage_account_tier" {
    type        = string
    description = "Defines the Tier to use for this storage account."
    default     = "Standard"
}

#https://docs.microsoft.com/en-us/azure/storage/common/storage-redundancy#redundancy-in-the-primary-region
variable "azurerm_account_replication_type" {
    type        = string
    description = "Data in an Azure Storage account is always replicated three times in the primary region."
    default     = "LRS"
}

variable "azurerm_storage_share_quota" {
    type        = string
    description = "The maximum size of the share, in gigabytes."
    default     = "50"
}
