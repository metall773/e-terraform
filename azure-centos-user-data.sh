#! /bin/bash
yum update -y
yum install util-linux -y

#Attaching data disk
#  https://docs.microsoft.com/en-us/azure/virtual-machines/linux/configure-lvm
pvcreate /dev/sdc
vgcreate data-vg01 /dev/sdc
lvcreate --extents 100%FREE --name data-lv01 data-vg01
mkfs -t ext4 /dev/data-vg01/data-lv01
mkdir -p /home/bitrix
echo "/dev/data-vg01/data-lv01  /home/bitrix  ext4  defaults  0  2" >>/etc/fstab
mount -a

