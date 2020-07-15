locals {
  vm_name = "${var.environment}-${var.web-linux-vm-prefix}-vm"
}

# Create a resource group if it doesn't exist
resource "azurerm_resource_group" "myterraformgroup" {
  name     = "${local.vm_name}-ResourceGroup"
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

# Create Network Security Group and rule
resource "azurerm_network_security_group" "myterraformnsg" {
  name                = "${local.vm_name}-NetworkSecurityGroup"
  location            = var.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
        application = var.app_name
        environment = var.environment
        vm-name     = local.vm_name
  }
}


resource "azurerm_network_security_rule" "allow_HTTP_rule" {
  name                        = "allow_HTTP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.myterraformgroup.name
  network_security_group_name = azurerm_network_security_group.myterraformnsg.name
}

resource "azurerm_network_security_rule" "allow_HTTPS_rule" {
  name                        = "allow_HTTPS"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.myterraformgroup.name
  network_security_group_name = azurerm_network_security_group.myterraformnsg.name
}

# Create network interface
resource "azurerm_network_interface" "myterraformnic" {
    name                = "${local.vm_name}-NIC"
    location            = azurerm_resource_group.myterraformgroup.location
    resource_group_name = azurerm_resource_group.myterraformgroup.name

    ip_configuration {
        name                          = "${local.vm_name}-NicConfiguration"
        subnet_id                     = azurerm_subnet.network-subnet.id
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

# Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Data template Bash bootstrapping file
data "template_file" "linux-vm-cloud-init" {
  template = file("azure-centos-user-data.sh")
}

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