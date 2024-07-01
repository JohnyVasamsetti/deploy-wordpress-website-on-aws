#!/bin/bash

yum update -y
yum install httpd -y

systemctl start httpd.service
systemctl enable httpd.service

cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -xvf latest.tar.gz

sudo mv wordpress/ /var/www/html
sudo sed -i 's|DocumentRoot "/var/www/html"|DocumentRoot "/var/www/html/wordpress"|g' /etc/httpd/conf/httpd.conf
sudo sed -i 's|DirectoryIndex index.html|DirectoryIndex index.php|g' /etc/httpd/conf/httpd.conf

sudo yum install -y php php-mysqlnd php-fpm
sudo systemctl restart httpd.service