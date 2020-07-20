#!/bin/bash
initlog=/root/cloudinit-log.txt
firewall_script=/root/firewall_script.sh

echo init script start > $initlog
echo init script path: $0 $_ >> $initlog

echo install pacakges start >> $initlog
yum update -y >> $initlog

#install bitrix env
#yum -y install epel-release \
#    http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
#    yum-utils >> $initlog
#yum-config-manager --enable remi-php72 >> $initlog

yum update -y
yum upgrade -y
yum install -y \
    bash-completion \
    bind-utils \
    cifs-utils \
    curl \
    cronie \
    ca-certificates \
    firewalld \
    git \
    openssl \
    openssh \
    jq \
    lvm2 \
    policycoreutils-devel \
    util-linux \
    wget >> $initlog
echo install pacakges finish  >> $initlog


#Enbale CentOS 7 autoupdate
if [[ ${install_autoupdate}="yes" ]]
  then
    echo enable autoupdate start >> $initlog
    yum install -y yum-cron >> $initlog
    sed -i 's/apply_updates = no/apply_updates = yes/g' /etc/yum/yum-cron.conf
    systemctl enable yum-cron.service >> $initlog
    systemctl start  yum-cron.service >> $initlog
    echo enable autoupdate finish >> $initlog
fi


#configure fail2ban for ssh
if [[ ${install_fail2ban}="yes" ]]
  then
    echo enable fail2ban start >> $initlog
    yum install -y fail2ban fail2ban-systemd >> $initlog
    cat << EOF > /etc/fail2ban/jail.d/sshd.local
[sshd]
enabled = true
port = ssh
action = firewallcmd-ipset
logpath = %(sshd_log)s
maxretry = 5
bantime = 3600
EOF
    chmod +x /etc/fail2ban/jail.d/sshd.local 
    systemctl enable fail2ban.service >> $initlog
    systemctl start  fail2ban.service >> $initlog
    #watch -n 2 -d fail2ban-client status sshd
    echo enable fail2ban finish >> $initlog
fi

echo mount datavol start >> $initlog
#Attaching data disk as LVM volume
#  https://docs.microsoft.com/en-us/azure/virtual-machines/linux/configure-lvm
pvcreate /dev/sdc >> $initlog
vgcreate data-vg01 /dev/sdc >> $initlog
lvcreate --extents 100%FREE --name data-lv01 data-vg01 >> $initlog
mkfs -t ext4 /dev/data-vg01/data-lv01 >> $initlog
mkdir -p /home/bitrix
echo "/dev/data-vg01/data-lv01  /home/bitrix  ext4  defaults  0  2" >>/etc/fstab
echo mount datavol finish >> $initlog

echo mount fileshare start >> $initlog
#mount the azure storage account network share (cifs) 
#  https://docs.microsoft.com/en-us/azure/virtual-machines/linux/mount-azure-file-storage-on-linux-using-smb#mount-the-share
mkdir -p /mnt/${storage_account}/${share_name}
echo '//${storage_account}.file.core.windows.net/${share_name} /mnt/${storage_account}/${share_name} cifs vers=3.0,username=${storage_account},password=${share_pass},dir_mode=0777,file_mode=0777' >> /etc/fstab
mount -a
echo mount fileshare finish >> $initlog

echo add ssh keys start >> $initlog
#enable ssh access by keys
git clone https://github.com/metall773/e-keys.git >> $initlog
mkdir -p /home/bitrix/.ssh
for n in `ls e-keys/*.pub`
  do 
    cat $n >> /home/azureuser/.ssh/authorized_keys
  done
echo add ssh keys finish >> $initlog

#bitrix default setup
if [[ ${install_bitrix}="yes" ]]
  then
    echo bitrix setup start >> $initlog
    useradd -ms /bin/bash bitrix
    usermod -aG wheel bitrix

    mkdir -p /home/bitrix/.ssh
    cp /home/azureuser/.ssh/authorized_keys /home/bitrix/.ssh/authorized_keys
    chmod 600 /home/bitrix/.ssh/authorized_keys
    
    #need to restore bitrix home directory the default SElinux context
    restorecon -v -R /home/bitrix >> $initlog
    # selinux allow 8888 for httpd
    semanage port -a -t http_port_t -p tcp 8888 >> $initlog
    #disable selinux
    seconfigs="/etc/selinux/config /etc/sysconfig/selinux"
    sed -i "s/SELINUX=\(enforcing\|permissive\)/SELINUX=disabled/" $seconfigs
    setenforce 0
    wget http://repos.1c-bitrix.ru/yum/bitrix-env.sh -O /root/bitrix-env.sh >> $initlog
    chmod +x /root/bitrix-env.sh
    echo bitrix setup finish, need reboot >> $initlog
  fi

#set timezone
echo set timezone >> $initlog
ln -fs /usr/share/zoneinfo/Europe/Moscow /etc/localtime >> $initlog


#configure services autostart
for n in crond firewalld 
  do
    echo enable $n.service >> $initlog
    systemctl enable $n.service >> $initlog
    systemctl start  $n.service >> $initlog
  done

#configure firewalld
echo firewalld configure start >> $initlog
echo \#!/bin/bash >> $firewall_script
for n in $(echo ${firewall_udp_ports} |jq .[])
  do
    echo firewalld add $n/udp  >> $initlog
    echo firewall-cmd --zone=public --add-port=$n/udp --permanent >> $firewall_script
    firewall-offline-cmd --zone=public --add-port=$n/tcp >> $initlog
  done
for n in $(echo ${firewall_tcp_ports} |jq .[])
  do
    echo firewalld add $n/tcp  >> $initlog
    echo firewall-cmd --zone=public --add-port=$n/tcp --permanent >> $firewall_script
    firewall-offline-cmd --zone=public --add-port=$n/tcp >> $initlog
  done
echo firewall-cmd --reload  >> $firewall_script
echo firewall-cmd --list-all  >> $firewall_script

systemctl restart firewalld.service >> $initlog
echo firewalld configure finish >> $initlog
echo init script done >> $initlog

#some debug info
echo ============================== >> $initlog
echo debug info: >> $initlog
echo firewall_tcp_ports ${firewall_tcp_ports} >> $initlog
echo firewall_udp_ports ${firewall_udp_ports} >> $initlog
echo install_fail2ban ${install_fail2ban} >> $initlog
echo install_bitrix ${install_bitrix} >> $initlog
echo install_autoupdate ${install_autoupdate} >> $initlog
export >> $initlog
whoami >> $initlog
pwd >> $initlog
env >> $initlog
echo ============================== >> $initlog

#bitrix reboot check
if [[ ${install_bitrix}="yes" ]]
  then
    echo bitrix setup preparing done, need reboot >> $initlog
    reboot
fi