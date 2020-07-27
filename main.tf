# Create a resource group for env shared resourses
resource "azurerm_resource_group" "terraformgroup" {
  name     = "${var.environment}-shared-resourses"
  location = var.location

  tags = {
    application = var.app_name
    environment = var.environment
  }
}

#create network
module "network" {
  source = "github.com/metall773/e-terraform-modules.git//modules/network"
    app_name       = var.app_name
    environment    = var.environment
    location = var.location
    resource_group = azurerm_resource_group.terraformgroup
}