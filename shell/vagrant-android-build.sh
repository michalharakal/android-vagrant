#!/bin/bash
HTTP_PROXY_ADDRESS=$1
HTTP_PROXY_PORT=$2

HTTP_PROXY=$HTTP_PROXY_ADDRESS:$HTTP_PROXY_PORT
HTTPS_PROXY_ADDRESS=$HTTP_PROXY
FTP_PROXY_ADDRESS=$HTTP_PROXY

if [ -n "$HTTP_PROXY" ]; then 
    # bash environment variable
    ANDROID_PROXY_SETTINGS="--proxy-port $HTTP_PROXY_PORT --proxy-host $HTTP_PROXY_ADDRESS"
fi


apt-get update -y
apt-get install openjdk-7-jdk -y
# For maven-plugin
apt-get install lib32z1-dev bison flex lib32ncurses5-dev libx11-dev gperf g++-multilib except -y
# Setup Android SDK
#Download and install the Android SDK
if [ ! -d "/usr/local/android-sdk" ]; then
    for a in $( wget -qO- $WGET_PROXY_SETTINGS http://developer.android.com/sdk/index.html | egrep -o "http://dl.google.com[^\"']*linux.tgz" ); do 
        wget $a && tar --wildcards --no-anchored -xvzf android-sdk_*-linux.tgz; mv android-sdk-linux /usr/local/android-sdk; chmod 777 -R /usr/local/android-sdk; rm android-sdk_*-linux.tgz;
    done
else
     echo "Android SDK already installed to /usr/local/android-sdk.  Skipping."
fi
# Add Android SDK to PATH
sudo -u vagrant echo export PATH=/usr/local/android-sdk/tools:\$PATH >> /home/vagrant/.bashrc
sudo -u vagrant echo export PATH=/usr/local/android-sdk/platform-tools:\$PATH >> /home/vagrant/.bashrc

# Maven
sudo -u vagrant wget $WGET_PROXY_SETTINGS http://download.nextag.com/apache/maven/maven-3/3.2.1/binaries/apache-maven-3.2.1-bin.tar.gz
sudo -u vagrant tar -xvzf apache-maven-3.2.1-bin.tar.gz
# Add Maven to PATH
sudo -u vagrant echo export PATH=/home/vagrant/apache-maven-3.2.1/bin:\$PATH >> /home/vagrant/.bashrc

# http://stackoverflow.com/questions/4681697/is-there-a-way-to-automate-the-android-sdk-installation/4682241#4682241
expect -c '
set timeout -1   ;
spawn sudo -u vagrant android update sdk $ANDROID_PROXY_SETTINGS -u; 
expect { 
    "Do you accept the license" { exp_send "y\r" ; exp_continue }
    eof
}
'

# ANDROID_HOME is for Maven
sudo -u vagrant echo export ANDROID_HOME=/usr/local/android-sdk/ >> /home/vagrant/.bashrc

sudo -u vagrant git clone https://github.com/mosabua/maven-android-sdk-deployer.git
sudo -u vagrant cd maven-android-sdk-deployer/
sudo -u vagrant mvn install
sudo -u vagrant mvn install
sudo -u vagrant cd extras/compatibility-v4/
sudo -u vagrant mvn clean install
