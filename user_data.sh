#!/bin/bash

sudo yum update -y

# install apache
sudo yum install -y httpd httpd-tools mod_ssl
sudo systemctl enable httpd
sudo systemctl start httpd

# install php 7.4
sudo yum install php php-common php-pear -y
sudo yum install php-{cgi,curl,mbstring,gd,mysqlnd,gettext,json,xml,fpm,intl,zip} -y

# install mysql5.7
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
sudo rpm -Uvh https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
sudo yum install mysql-community-server -y
sudo systemctl enable mysqld
sudo systemctl start mysqld

# download wordpress files
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
sudo cp -r wordpress/* /var/www/html/

# update root password and create wp_user along with db and grant the permission to user
TEMP_PASSWORD=$(sudo grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
NEW_ROOT_PASSWORD="Akash@123"
DB_NAME="wordpress"
DB_USER="wp_user"
DB_PASSWORD="Akash@6622"
DB_HOST="localhost"
sudo mysql --connect-expired-password -u root -p"$TEMP_PASSWORD" <<EOF
ALTER USER 'root'@'$DB_HOST' IDENTIFIED WITH mysql_native_password BY '$NEW_ROOT_PASSWORD';
CREATE USER '$DB_USER'@'$DB_HOST' IDENTIFIED BY '$DB_PASSWORD';
CREATE DATABASE $DB_NAME;
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'$DB_HOST';
EOF

# create the wp-config.php file
sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
WP_CONFIG_FILE="/var/www/html/wp-config.php"
sudo sed -i "s/database_name_here/$DB_NAME/" $WP_CONFIG_FILE
sudo sed -i "s/username_here/$DB_USER/" $WP_CONFIG_FILE
sudo sed -i "s/password_here/$DB_PASSWORD/" $WP_CONFIG_FILE
sudo sed -i "s/localhost/$DB_HOST/" $WP_CONFIG_FILE
sudo service httpd restart

