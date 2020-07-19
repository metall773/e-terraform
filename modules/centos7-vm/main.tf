locals {
  vm_name = "${var.environment}-${var.web-linux-vm-prefix}-vm"
}

# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "myterraformgroup" {
  name     = "${local.vm_name}"
  location = var.location

  tags = {
        application = var.app_name
        environment = var.environment
        vm-name     = local.vm_name
  }
}

# Create public IPs
resource "azurerm_public_ip" "myterraformpublicip" {
  name                = "${local.vm_name}-PublicIP"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Dynamic"
  domain_name_label   = local.vm_name

  tags = {
        application = var.app_name
        environment = var.environment
        vm-name     = local.vm_name
  }
}

# Create network interface
resource "azurerm_network_interface" "myterraformnic" {
    name                = "${local.vm_name}-NIC"
    location            = azurerm_resource_group.myterraformgroup.location
    resource_group_name = azurerm_resource_group.myterraformgroup.name

    ip_configuration {
        name                          = "${local.vm_name}-NicConfiguration"
        subnet_id                     = var.network-subnet
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
    }

    tags = {
        application = var.app_name
        environment = var.environment
        vm-name     = local.vm_name
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.myterraformnic.id
  network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.myterraformgroup.name
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
  name                     = "diag${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.myterraformgroup.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
        application = var.app_name
        environment = var.environment
        vm-name     = local.vm_name
  }
}

# Create storage account for network share
resource "azurerm_storage_account" "mystorageaccount-files" {
  name                     = "files${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.myterraformgroup.name
  location                 = var.location
  account_tier             = var.azurerm_storage_account_tier
  account_replication_type = var.azurerm_account_replication_type

  tags = {
        application = var.app_name
        environment = var.environment
        vm-name     = local.vm_name
  }
}

resource "azurerm_storage_share" "myfileshare" {
  name                 = "${local.vm_name}-files-share"
  storage_account_name = azurerm_storage_account.mystorageaccount-files.name
  quota                = var.azurerm_storage_share_quota

  acl {
    id = "${random_id.randomId.hex}MTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTI"

    access_policy {
      permissions = "rwdl"
      start       = "2019-07-02T09:38:21.0000000Z"
      expiry      = "2019-07-02T10:38:21.0000000Z"
    }
  }
}

# Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}



# /home/bitrix disk
resource "azurerm_managed_disk" "linux-vm-managed_disk" {
  name                 = "${local.vm_name}-managed-data-disk"
  location             = azurerm_resource_group.myterraformgroup.location
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  storage_account_type = var.storage_account_type
  create_option        = "Empty"
  os_type              = "Linux"
  disk_size_gb         = var.managed_disk_size_gb
      tags = {
        application = var.app_name
        environment = var.environment
        vm-name     = local.vm_name
    }
}

resource "azurerm_virtual_machine_data_disk_attachment" "linux-vm-managed_disk" {
  virtual_machine_id = azurerm_linux_virtual_machine.myterraformvm.id
  managed_disk_id    = azurerm_managed_disk.linux-vm-managed_disk.id
  lun                = 1
  caching            = "None"
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "myterraformvm" {
  name                  = local.vm_name
  location              = var.location
  resource_group_name   = azurerm_resource_group.myterraformgroup.name
  network_interface_ids = [azurerm_network_interface.myterraformnic.id]
  size                  = var.web-linux-vm-size

  os_disk {
    name                 = "${local.vm_name}-OsDisk"
    caching              = "ReadWrite"
    storage_account_type = var.storage_account_type
  }

  source_image_reference {
    offer     = lookup(var.web-linux-vm-image, "offer", null)
    publisher = lookup(var.web-linux-vm-image, "publisher", null)
    sku       = lookup(var.web-linux-vm-image, "sku", null)
    version   = lookup(var.web-linux-vm-image, "version", null)
  }

  computer_name                   = local.vm_name
  admin_username                  = var.web-linux-admin-username
  disable_password_authentication = true
  custom_data                     = base64encode(data.template_file.linux-vm-cloud-init.rendered)

  admin_ssh_key {
    username   = var.web-linux-admin-username
    public_key = tls_private_key.example_ssh.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }

    tags = {
        application = var.app_name
        environment = var.environment
        name        = local.vm_name
    }
}