android-vagrant
===============

Based on blog article from [Chrsitopher Biscardi](http://www.christopherbiscardi.com/2014/03/08/getting-started-with-robolectric-headless-android-testing-with-vagrant/)
[Github Gist] (https://gist.github.com/ChristopherBiscardi/9383725)


## Proxy support
proxy support is possible via (vagrant-proxy plugin) [https://github.com/tmatilai/vagrant-proxyconf]. 

Your proxy settings should be set in file _shell/config.yaml_

Install the plugin:

```sh
export http_proxy=YOUR_PROXY
vagrant plugin install vagrant-proxyconf
```



On Mac OS X you may have troubles beacuse missing _gem nokogiri_. Working solution was described here: http://bullrico.com/2012/07/12/installing-nokogiri-after-updating-homebrew/

## Android 
### Installation
Installation of android SDK requires confirmation of licences (also in console). 
Solution from http://stackoverflow.com/questions/4681697/is-there-a-way-to-automate-the-android-sdk-installation/4682241 works well.

### maven SDK deployer
* android-maven-sdk deployer (comming)
* support for http proxy (comming)
 

### Custom maven settings
TBD

