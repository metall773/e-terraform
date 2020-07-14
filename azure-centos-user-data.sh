#! /bin/bash
yum update -y
yum install util-linux -y

#Attaching data disk as LVM
#  https://docs.microsoft.com/en-us/azure/virtual-machines/linux/configure-lvm
pvcreate /dev/sdc
vgcreate data-vg01 /dev/sdc
lvcreate --extents 100%FREE --name data-lv01 data-vg01
mkfs -t ext4 /dev/data-vg01/data-lv01
mkdir -p /home/bitrix
echo "/dev/data-vg01/data-lv01  /home/bitrix  ext4  defaults  0  2" >>/etc/fstab
mount -a

#install bitrix env
yum -y install epel-release \
    http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
    yum-utils && \
    yum-config-manager --enable remi-php72

yum update -y && yum upgrade -y && yum install -y initscripts \
    wget \
    httpd \
    curl \
    cronie \
    ca-certificates \
    openssl \
    openssh \
    git \
    nano \
    curl-devel \
    expat-devel \
    gettext-devel \
    openssl-devel \
    zlib-devel \
    pcre-devel \
    gcc \
    gcc-c++ \
    kernel-devel \
    bind-utils \
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
    nginx
yum clean -y all

# Create pid dir and send logs to stderr for Nginx
mkdir /run/nginx \
mkdir /var/log/nginx \
mkdir /home/bitrix/www

useradd -ms /bin/bash bitrix
chown -R bitrix:bitrix /home/bitrix
chmod -R 777 /tmp
mkdir -p /home/bitrix/www/bitrix/tmp
chmod -R 777 /home/bitrix/www/bitrix/tmp

ln -fs /usr/share/zoneinfo/Europe/Moscow /etc/localtime