output "centos7_vm1" {
    value = "ssh ${module.centos7-vm1.username}@${module.centos7-vm1.fqdn}"
}

output "centos7_vm2" {
    value = "ssh ${module.centos7-vm2.username}@${module.centos7-vm2.fqdn}"
}

output "centos7_vm3" {
    value = "ssh ${module.centos7-vm3.username}@${module.centos7-vm3.fqdn}"
}

output "centos7_vm4" {
    value = "ssh ${module.centos7-vm4.username}@${module.centos7-vm4.fqdn}"
}

output "centos7_vm5" {
    value = "ssh ${module.centos7-vm5.username}@${module.centos7-vm5.fqdn}"
}

output "centos7_vm6" {
    value = "ssh ${module.centos7-vm6.username}@${module.centos7-vm6.fqdn}"
}

output "centos7_vm7" {
    value = "ssh ${module.centos7-vm7.username}@${module.centos7-vm7.fqdn}"
}

output "centos7_vm8" {
    value = "ssh ${module.centos7-vm5.username}@${module.centos7-vm5.fqdn}"
}

output "centos7_vm9" {
    value = "ssh ${module.centos7-vm6.username}@${module.centos7-vm6.fqdn}"
}

output "centos7_vm10" {
    value = "ssh ${module.centos7-vm7.username}@${module.centos7-vm7.fqdn}"
}

output "centos7_vm11" {
    value = "ssh ${module.centos7-vm7.username}@${module.centos7-vm7.fqdn}"
}

output "win-vm1" {
    value = "rdp ${module.win-vm1.username}@${module.win-vm1.fqdn}"
}

output "win-vm2" {
    value = "rdp ${module.win-vm2.username}@${module.win-vm2.fqdn}"
}

/*
output "win-vm2-db" {
    depends_on  = [module.postgresql_db1]
    value = "pqsl -U ${module.postgresql_db1.username} -h ${module.postgresql_db1.fqdn} -d test"
}
*/
