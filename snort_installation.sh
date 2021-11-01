#pre-requisite libraries for snort

sudo apt install -y gcc libpcre3-dev zlib1g-dev libluajit-5.1-dev \
libpcap-dev openssl libssl-dev libnghttp2-dev libdumbnet-dev \
bison flex libdnet autoconf libtool

sudo apt install make

#download source code from snort and install it
mkdir ~/snort_src && cd ~/snort_src
wget https://www.snort.org/downloads/snort/daq-2.0.7.tar.gz

#extract the source code and jump into the new directory with the following commands.
tar -xvzf daq-2.0.7.tar.gz
cd daq-2.0.7

#The latest version requires an additional step to auto reconfigure DAQ before running the config. Use the command below which requires you need to have autoconf and libtool installed.
autoreconf -f -i

#run the configuration script using its default values, then compile the program with make and finally install DAQ
./configure --disable-dependency-tracking 
make 
sudo make install

#With the DAQ installed you can get started with Snort, change back to the download folder
cd ~/snort_src

#Next, download the Snort source code with wget
wget https://www.snort.org/downloads/snort/snort-2.9.18.1.tar.gz

#Once the download is complete, extract the source and change into the new directory with these commands.
tar -xvzf snort-2.9.18.1.tar.gz
cd snort-2.9.18.1

#configure the installation with sourcefire enabled, run make and make install.
./configure --enable-sourcefire && make && sudo make install


#Configuring Snort to run in NIDS mode
#Next, you will need to configure Snort for your system. This includes editing some configuration files, downloading the rules that Snort will follow, and taking Snort for a test run.
#Start with updating the shared libraries using the command underneath.
sudo ldconfig

#Snort on Ubuntu gets installed to /usr/local/bin/snort directory, it is good practice to create a symbolic link to /usr/sbin/snort.
sudo ln -s /usr/local/bin/snort /usr/sbin/snort

#Setting up username and folder structure
#To run Snort on Ubuntu safely without root access, you should create a new unprivileged user and a new user group for the daemon to run under.

sudo groupadd snort
sudo useradd snort -r -s /sbin/nologin -c SNORT_IDS -g snort

#Then create the folder structure to house the Snort configuration, just copy over the commands below.
sudo mkdir -p /etc/snort/rules
sudo mkdir /var/log/snort
sudo mkdir /usr/local/lib/snort_dynamicrules

#Set the permissions for the new directories accordingly.

sudo chmod -R 5775 /etc/snort
sudo chmod -R 5775 /var/log/snort
sudo chmod -R 5775 /usr/local/lib/snort_dynamicrules
sudo chown -R snort:snort /etc/snort
sudo chown -R snort:snort /var/log/snort
sudo chown -R snort:snort /usr/local/lib/snort_dynamicrules

#Create new files for the white and blacklists as well as the local rules.

sudo touch /etc/snort/rules/white_list.rules
sudo touch /etc/snort/rules/black_list.rules
sudo touch /etc/snort/rules/local.rules

#Then copy the configuration files from the download folder.

sudo cp ~/snort_src/snort-2.9.18.1/etc/*.conf* /etc/snort
sudo cp ~/snort_src/snort-2.9.18.1/etc/*.map /etc/snort

#Next up, you will need to download the detection rules Snort will follow to identify potential threats. Snort provides three tiers of rule sets, community, registered and subscriber rules.

#Community rules are freely available although slightly limited.
#By registering for free on their website you get access to your Oink code, which lets you download the registered users rule sets.
#Lastly, subscriber rules are just that, available to users with an active subscription to Snort services.
#Underneath you can find instructions for downloading both community rules or registered user rule sets.

#Community rules
wget https://www.snort.org/rules/community -O ~/community.tar.gz
sudo tar -xvf ~/community.tar.gz -C ~/
sudo cp ~/community-rules/* /etc/snort/rules
#By default, Snort on Ubuntu expects to find a number of different rule files which are not included in the community rules. You can easily comment out the unnecessary lines using the sed command underneath.
sudo sed -i 's/include \$RULE\_PATH/#include \$RULE\_PATH/' /etc/snort/snort.conf

#Obtaining registered user rules
wget https://www.snort.org/rules/snortrules-snapshot-29181.tar.gz?oinkcode=365e3466f19f7f41e6d66a7129c23e9bc4a7a4b5 -O ~/registered.tar.gz

# extract the rules over to your configuration directory
sudo tar -xvf ~/registered.tar.gz -C /etc/snort

#Configuring the network and rule sets

#This has to be done manually by going into UBUNTU machine and use VI editor to change foldername to match /etc/snort, HOME_NET ips to protect, etc

#validate the settings
sudo snort -T -c /etc/snort/snort.conf
#testing the configuration
#sudo nano /etc/snort/rules/local.rules
#here manually add rules to alert the specific IP detection on any specific protocol like TCP or ICMP



