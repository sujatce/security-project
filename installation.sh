#!/bin/bash

echo -e "\nFollowing command updates the APT packages and also upgrades all latest patches which ensures the security and functional aspects of server\n"
sudo apt-get update -y 
sudo apt-get upgrade -y

echo -e "\nFollowing command installs Apache Web Server"
sudo apt-get install apache2 apache2-doc apache2-utils libexpat1 ssl-cert -y

echo -e "\nFollowing command installas PHP and its related modules\n"
sudo apt-get install php libapache2-mod-php php-mysql -y

echo -e "\nFollowing command installs MySQL and it's related libraries\n"
sudo apt-get install mysql-server mysql-client -y

echo -e "\nFollowing command setups Permissions for /var/www\n"
sudo chown -R www-data:www-data /var/www

echo -e "\nEnable Modules\n"
sudo a2enmod rewrite
# Enable SSL Module and headers in Apache
sudo a2enmod ssl
sudo a2enmod headers
# Enable SSL Virtual Host
sudo a2ensite default-ssl
#check if there is any syntax error in config files
sudo apache2ctl configtest


echo -e "\nFollowing command restarts Apache\n"
sudo service apache2 restart

echo -e "\nInstallation of LAMP is successfully finished"

exit 0
