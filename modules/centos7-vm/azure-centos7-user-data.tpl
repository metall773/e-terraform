#! /bin/bash
yum update -y

#install bitrix env
yum -y install epel-release \
    http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
    yum-utils
yum-config-manager --enable remi-php72

yum update -y
yum upgrade -y
yum install -y \
    bash-completion \
    bind-utils \
    cifs-utils \
    curl \
    cronie \
    ca-certificates \
    fail2ban \
    fail2ban-systemd \
    firewalld \
    git \
    httpd \
    openssl \
    openssh \
    lvm2 \
    nginx \
    php \
    php-cli \
    php-json \
    php-iconv \
    php-intl \
    php-ftp \
    php-xdebug \
    php-mcrypt \
    php-mbstring \
    php-soap \
    php-gmp \
    php-pdo_odbc \
    php-dom \
    php-pdo \
    php-zip \
    php-mysqli \
    php-bcmath \
    php-gd \
    php-odbc \
    php-pdo_mysql \
    php-gettext \
    php-xmlreader \
    php-xmlwriter \
    php-tokenizer \
    php-xmlrpc \
    php-bz2 \
    php-curl \
    php-ctype \
    php-session \
    php-exif \
    php-opcache \
    php-ldap \
    util-linux \
    wget \
    yum-cron
yum clean -y all


#Attaching data disk as LVM volume
#  https://docs.microsoft.com/en-us/azure/virtual-machines/linux/configure-lvm
pvcreate /dev/sdc
vgcreate data-vg01 /dev/sdc
lvcreate --extents 100%FREE --name data-lv01 data-vg01
mkfs -t ext4 /dev/data-vg01/data-lv01
mkdir -p /home/bitrix
echo "/dev/data-vg01/data-lv01  /home/bitrix  ext4  defaults  0  2" >>/etc/fstab

#mount the azure storage account network share (cifs) 
#  https://docs.microsoft.com/en-us/azure/virtual-machines/linux/mount-azure-file-storage-on-linux-using-smb#mount-the-share
mkdir -p /mnt/${storage_account}/${share_name}
echo '//${storage_account}.file.core.windows.net/${share_name} /mnt/${storage_account}/${share_name} cifs vers=3.0,username=${storage_account},password=${share_pass},dir_mode=0777,file_mode=0777' >> /etc/fstab
mount -a


#enable ssh access by keys
git clone https://github.com/metall773/e-keys.git
mkdir -p /home/bitrix/.ssh
for n in `ls e-keys/*.pub`
  do 
    cat $n >> /home/azureuser/.ssh/authorized_keys
  done


#create and configure bitrix user
useradd -ms /bin/bash bitrix
usermod -aG wheel bitrix

mkdir -p /home/bitrix/www
wget http://www.1c-bitrix.ru/download/scripts/bitrixsetup.php -O /home/bitrix/www/bitrixsetup.php

mkdir -p /home/bitrix/.ssh
cp /home/azureuser/.ssh/authorized_keys /home/bitrix/.ssh/authorized_keys
chmod 600 /home/bitrix/.ssh/authorized_keys
chown -R bitrix:bitrix /home/bitrix
chmod -R 777 /tmp
mkdir -p /home/bitrix/www/bitrix/tmp
chmod -R 777 /home/bitrix/www/bitrix/tmp
#bitrix default setup
#rm /etc/nginx/* -Rf
#rm /etc/httpd/* -Rf
#need to restore bitrix home directory the default SElinux context
restorecon -v -R /home/bitrix


#set timezone
ln -fs /usr/share/zoneinfo/Europe/Moscow /etc/localtime


#Enbale CentOS 7 autoupdate
sed -i 's/apply_updates = no/apply_updates = yes/g' /etc/yum/yum-cron.conf


#configure fail2ban for ssh
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
#watch -n 2 -d fail2ban-client status sshd


#configure services autostart
for n in nginx httpd crond yum-cron firewalld fail2ban 
  do 
    systemctl enable $n.service
    systemctl start  $n.service
  done


#allow HTTP HTTPS
firewall-cmd --zone=public --add-service=http  --permanent
firewall-cmd --zone=public --add-service=https --permanent
firewall-cmd --reload