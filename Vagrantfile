# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64"
  config.vm.provision "shell", path: "vagrant-android-build.sh"
  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--usb', 'on']
    vb.customize ['usbfilter', 'add', '0', '--target', :id, '--name', '1197123b', '--vendorid', '0x04e8']
    vb.customize ['usbfilter', 'add', '0', '--target', :id, '--name', 'android', '--vendorid', '0x18d1']
  end  
end
