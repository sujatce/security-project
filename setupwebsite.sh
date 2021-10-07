#!/bin/bash

echo -e "\nFollowing command installs git\n"
sudo apt-get install git -y

cd /var/www/html/
sudo git clone https://github.com/sujatce/csun

printf "
RewriteEngine On
Redirect /index.html /csun/index.php
" | sudo tee /var/www/html/.htaccess

sudo mysql -h localhost -u root <csun/phplogin.sql

exit 0
