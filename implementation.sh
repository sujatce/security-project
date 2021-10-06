#!/bin/bash

echo -e "\nFollowing set of commands enable UBUNTU Firewall and sets rules to allow only OpenSSH, HTTP & HTTPS traffic"
sudo ufw status
#enable ubuntu firewall
sudo ufw enable
#check the list of applications enabled via ubuntu firewall
sudo ufw app list
#enable OpenSSH on firewall
sudo ufw allow "OpenSSH"
#enable Apache Full on firewall, this could typically enable port 80 and 443 as well
sudo ufw allow "Apache Full"
#enable firewall to acceept http and https traffic from any IP using the following 3 commands
sudo ufw allow http
sudo ufw allow https
sudo ufw allow proto tcp from any to any port 80,443
#Any policy to disable any subnet or specific IP can be entered here - Sample below

#Following command blocks a subnet (Currently commented, to be used for a speicific situation)
#sudo ufw deny from X.Y.Z.0/24

#Following command blocks a specific IP address (incase of identified brute force attack from specific IP, this will be handful)
#sudo ufw deny from X.Y.Z.0

#Following command can be used to allow SSH Connections from only specific IP (we haven't done that as we don't have STATIC IP always)
#sudo ufw allow from X.Y.Z.A proto tcp to any port 22

#Since MySQL is always accessed by Web Server locally, there is no need to open MYSQL port to outside world (3306)
#If needed to access MySQL for any query/reporting purpose from remote server, we would open it using the following command
#sudo ufw allow from X.Y.Z.A to any port 3306
# Once again, we don't have static IP, hence we login to server directly using OpenSSH and query it out there. This is more secure for education purpose.

#Webserver needs to send email out, hence allow port 25 (Not implemented yet)
#sudo ufw allow out 25

exit 0