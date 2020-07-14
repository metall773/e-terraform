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
    curl \
    cronie \
    ca-certificates \
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

#Attaching data disk as LVM
#  https://docs.microsoft.com/en-us/azure/virtual-machines/linux/configure-lvm
pvcreate /dev/sdc
vgcreate data-vg01 /dev/sdc
lvcreate --extents 100%FREE --name data-lv01 data-vg01
mkfs -t ext4 /dev/data-vg01/data-lv01
mkdir -p /home/bitrix
echo "/dev/data-vg01/data-lv01  /home/bitrix  ext4  defaults  0  2" >>/etc/fstab
mount -a

#add and configure bitrix user
mkdir -p /home/bitrix/www
wget http://www.1c-bitrix.ru/download/scripts/bitrixsetup.php -O /home/bitrix/www/bitrixsetup.php

useradd -ms /bin/bash bitrix
mkdir -p /home/bitrix/.ssh
cp /home/azureuser/.ssh/authorized_keys /home/bitrix/.ssh/authorized_keys
chmod 600 /home/bitrix/.ssh/authorized_keys
chown -R bitrix:bitrix /home/bitrix
chmod -R 777 /tmp
mkdir -p /home/bitrix/www/bitrix/tmp
chmod -R 777 /home/bitrix/www/bitrix/tmp

#set timezone
ln -fs /usr/share/zoneinfo/Europe/Moscow /etc/localtime

systemctl enable nginx.service
systemctl enable httpd.service
systemctl enable crond.service
systemctl start nginx.service
systemctl start httpd.service
systemctl start crond.service

#Enbale CentOS autoupdate
sed -i 's/apply_updates = no/apply_updates = yes/g' /etc/yum/yum-cron.conf
systemctl enable yum-cron.service
systemctl start  yum-cron.service