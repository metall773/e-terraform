output "centos7_vm" {
    value = "ssh ${module.centos7-vm.username}@${module.centos7-vm.fqdn}"
}

output "centos7_vm2" {
    value = "ssh ${module.centos7-vm2.username}@${module.centos7-vm2.fqdn}"
}

output "win1-vm" {
    value = "rdp ${module.win1-vm.username}@${module.win1-vm.fqdn}"
}

output "centos7_vm_db" {
    value = "pqsl -h ${module.postgresql_db1.username} -U ${module.postgresql_db1.fqdn}"
}

output "centos7_vm2_db" {
    value = "mysql -h ${module.mysql_db1.fqdn} -u ${module.mysql_db1.username} -p"
}

