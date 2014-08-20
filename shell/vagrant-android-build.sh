#!/bin/bash
HTTP_PROXY_HOST=$1
HTTP_PROXY_PORT=$2
MAVEN_PROXY_SETTINGS=

apt-get update -y
apt-get install openjdk-7-jdk -y
# For maven-plugin
apt-get install lib32z1-dev bison flex lib32ncurses5-dev libx11-dev gperf g++-multilib expect git -y


# proxy setup
if [ -n "$HTTP_PROXY" ]; then
    HTTP_PROXY=HTTP_PROXY_HOST:$HTTP_PROXY_PORT
    HTTPS_PROXY_ADDRESS=$HTTP_PROXY 
    # setup proxy for android SDK tool
    sudo -u vagrant mkdir /home/vagrant/.android
    sudo -u vagrant echo http.proxyPort=$HTTP_PROXY_PORT >> /home/vagrant/.android/androidtool.cfg
    sudo -u vagrant echo http.proxyHost=$HTTP_PROXY_HOST >> /home/vagrant/.android/androidtool.cfg
    # maven proxy
    # TBD via .m2/settings.xml
    
    
    
    # git proxy settings
    sudo -u git config --global http.proxy http://192.168.1.112:3128
fi


# Setup Android SDK
#Download and install the Android SDK
if [ ! -d "/usr/local/android-sdk" ]; then
    # download links to SDK files from the main SDK html page
    for a in $( wget -qO- http://developer.android.com/sdk/index.html | egrep -o "http://dl.google.com[^\"']*linux.tgz" ); do 
        echo $a
        wget $a && tar --wildcards --no-anchored -xvzf android-sdk_*-linux.tgz; mv android-sdk-linux /usr/local/android-sdk; chmod 777 -R /usr/local/android-sdk; rm android-sdk_*-linux.tgz;
    done
    
    
    # Add Android SDK to PATH
    sudo -u vagrant echo export PATH=/usr/local/android-sdk/tools:\$PATH >> /home/vagrant/.bashrc
    sudo -u vagrant echo export PATH=/usr/local/android-sdk/platform-tools:\$PATH >> /home/vagrant/.bashrc
    # ANDROID_HOME is for Maven
    sudo -u vagrant echo export ANDROID_HOME=/usr/local/android-sdk/ >> /home/vagrant/.bashrc
else
     echo "Android SDK already installed to /usr/local/android-sdk.  Skipping."
fi

# Maven
if [ ! -d "/usr/local/maven/apache-maven-3.1.1" ]; then
    sudo -u vagrant wget $WGET_PROXY_SETTINGS http://mirror.23media.de/apache/maven/maven-3/3.1.1/binaries/apache-maven-3.1.1-bin.tar.gz
    tar -xvzf apache-maven-3.1.1-bin.tar.gz; mv apache-maven-3.1.1 /usr/local/apache-maven-3.1.1; chmod 777 -R /usr/local/apache-maven-3.1.1; rm apache-maven-3.1.1-bin.tar.gz;
    # Add Maven to PATH
    sudo -u vagrant echo export PATH=/usr/local/apache-maven-3.1.1/bin:\$PATH >> /home/vagrant/.bashrc
    sudo -u vagrant echo export M2_HOME=/usr/local/apache-maven-3.1.1 >> /home/vagrant/.bashrc
    sudo -u vagrant export M2_HOHE = /usr/local/apache-maven-3.1.1
    
    
else
    echo "Maven installed in /usr/localmaven. Skipping."
fi

# http://stackoverflow.com/questions/4681697/is-there-a-way-to-automate-the-android-sdk-installation/4682241#4682241

# android tools
expect -c '
set timeout -1   ;
spawn sudo -u vagrant /usr/local/android-sdk/tools/android  update sdk  --no-ui --all --filter "tools, platform-tools, build-tools-20.0.0"  ;

expect { 
    "Do you accept the license" { exp_send "y\r" ; exp_continue }
    eof
    }
'

# android support
expect -c '
set timeout -1   ;
spawn sudo -u vagrant /usr/local/android-sdk/tools/android  update sdk  --no-ui --all --filter "extra-android-m2repository,\
    extra-android-support,\
    extra-google-admob_ads_sdk,\
    extra-google-analytics_sdk_v2,\
    extra-google-google_play_services_froyo,\
    extra-google-google_play_services,\
    extra-google-m2repository,\
    extra-google-play_apk_expansion,\
    extra-google-play_billing,\
    extra-google-play_licensing,\
    extra-google-webdriver"  ;
expect { 
    "Do you accept the license" { exp_send "y\r" ; exp_continue }
    eof
    }
'

expect -c '
set timeout -1   ;
spawn sudo -u vagrant /usr/local/android-sdk/tools/android  update sdk  --no-ui --all --filter "android-19, sysimg-19, addon-google_apis-google-19 "  ;
expect { 
    "Do you accept the license" { exp_send "y\r" ; exp_continue }
    eof
    }
'

expect -c '
set timeout -1   ;
spawn sudo -u vagrant /usr/local/android-sdk/tools/android  update sdk  --no-ui --all --filter "android-17, sysimg-17, addon-google_apis-google-17 "  ;
expect { 
    "Do you accept the license" { exp_send "y\r" ; exp_continue }
    eof
    }
'


expect -c '
set timeout -1   ;
spawn sudo -u vagrant /usr/local/android-sdk/tools/android  update sdk  --no-ui --all --filter "android-9, sysimg-9, addon-google_apis-google-9" ;
expect { 
    "Do you accept the license" { exp_send "y\r" ; exp_continue }
    eof
    }
'

expect -c '
set timeout -1   ;
spawn sudo -u vagrant /usr/local/android-sdk/tools/android  update sdk  --no-ui --all --filter "android-8, sysimg-8, addon-google_apis-google-8" ;
expect { 
    "Do you accept the license" { exp_send "y\r" ; exp_continue }
    eof
    }
'

expect -c '
set timeout -1   ;
spawn sudo -u vagrant /usr/local/android-sdk/tools/android  update sdk  --no-ui --all --filter "android-16, sysimg-16, addon-google_apis-google-16" ;
expect { 
    "Do you accept the license" { exp_send "y\r" ; exp_continue }
    eof
    }
'


# maven android sdk deployers
if [ ! -d "/home/vagrant/maven-android-sdk-deployer" ]; then
    sudo -u vagrant git clone https://github.com/mosabua/maven-android-sdk-deployer.git
fi
    
cd /home/vagrant/maven-android-sdk-deployer
sudo -u vagrant /usr/local/apache-maven-3.1.1/bin/mvn $MAVEN_PROXY_SETTINGS clean install
cd /home/vagrant/maven-android-sdk-deployer/extras/compatibility-v4/
sudo -u vagrant /usr/local/apache-maven-3.1.1/bin/mvn $MAVEN_PROXY_SETTINGS clean install
cd /home/vagrant/maven-android-sdk-deployer/extras/compatibility-v7/
sudo -u vagrant /usr/local/apache-maven-3.1.1/bin/mvn $MAVEN_PROXY_SETTINGS clean install