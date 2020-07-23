module "mysql_db1" {
  source = "./modules/mysql"
    app_name                         = "${var.app_name}"
    environment                      = "${var.environment}"
    vm_resource_group                = module.centos7-vm2.vm_resource_group.name
    db-prefix                        = module.centos7-vm2.vm_resource_group.name
    public_network_access_enabled    = true
    public_ip_address                = module.centos7-vm2.public_ip_address
}

module "postgresql_db1" {
  source = "./modules/postgresql"
    app_name                         = "${var.app_name}"
    environment                      = "${var.environment}"
    vm_resource_group                = module.centos7-vm.vm_resource_group.name
    db-prefix                        = module.centos7-vm.vm_resource_group.name
    public_network_access_enabled    = true
    public_ip_address                = module.centos7-vm.public_ip_address
}