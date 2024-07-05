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

# get the rds creds from the rds-master secret
secret_value=$(aws secretsmanager get-secret-value --secret-id rds-master --query SecretString --output text)
db_host=$(echo $secret_value | jq -r '.host')
db_username=$(echo $secret_value | jq -r '.username')
db_password=$(echo $secret_value | jq -r '.password')
db_name=$(echo $secret_value | jq -r '.dbname')

# create the wp-config.php file
sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
wp_config_file="/var/www/html/wp-config.php"
sudo sed -i "s/database_name_here/$db_name/" $wp_config_file
sudo sed -i "s/username_here/$db_username/" $wp_config_file
sudo sed -i "s/password_here/$db_password/" $wp_config_file
sudo sed -i "s/localhost/$db_host/" $wp_config_file
sudo service httpd restart

