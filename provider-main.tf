# State file location
terraform {
    backend "azurerm" {
        resource_group_name   = "terraform-state"
        storage_account_name  = "4terraform2state"
        container_name        = "tstate"
        key                   = var.environment"-terraform.tfstate"
    }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
    # The "feature" block is required for AzureRM provider 2.x. 
    # If you're using version 1.x, the "features" block is not allowed.
    version = "~>2.0"
    
    subscription_id = var.ARM_SUBSCRIPTION_ID
    client_id       = var.ARM_CLIENT_ID
    client_secret   = var.ARM_CLIENT_SECRET
    tenant_id       = var.ARM_TENANT_ID
    
    features {}
}