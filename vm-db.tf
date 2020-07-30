module "postgresql_db1" {
  source = "github.com/metall773/e-terraform-modules.git//modules/postgresql"
    app_name                         = var.app_name
    environment                      = var.environment
    vm_resource_group                = module.win-vm2.vm_resource_group.name
    db-prefix                        = module.win-vm2.vm_resource_group.name
    public_network_access_enabled    = false
    public_ip_address                = module.win-vm2.public_ip_address
    db-size                          = "B_Gen5_2"
}