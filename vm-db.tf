#module "postgresql_db1" {
#  source = "github.com/metall773/e-terraform-modules.git//modules/postgresql"
#    app_name                         = var.app_name
#    environment                      = var.environment
#    vm_resource_group                = module.win-vm2.vm_resource_group.name
#    db-prefix                        = module.win-vm2.vm_resource_group.name
#    public_network_access_enabled    = true
#    public_ip_address                = module.win-vm2.public_ip_address
#    db-size                          = "GP_Gen5_4"
#    db-version                       = "10"
#}
