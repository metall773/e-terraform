# Create a resource group for env shared resourses
resource "azurerm_resource_group" "terraformgroup" {
  name     = "${var.environment}-shared-resourses"
  location = var.location

  tags = {
    application = var.app_name
    environment = var.environment
  }
}