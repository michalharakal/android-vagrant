# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

require 'yaml'

dir = File.dirname(File.expand_path(__FILE__))

configValues = YAML.load_file("#{dir}/shell/config.yaml")
data         = configValues['shell-config']
http_proxy = "#{data['network']['http_proxy_address']}" + ":" + "#{data['network']['http_proxy_port']}"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "hashicorp/precise64"
  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--usb', 'on']
    vb.customize ['usbfilter', 'add', '0', '--target', :id, '--name', '1197123b', '--vendorid', '0x04e8']
    vb.customize ['usbfilter', 'add', '0', '--target', :id, '--name', 'android', '--vendorid', '0x18d1']
  end  
  
  config.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  if (http_proxy != ":")  
  if Vagrant.has_plugin?("vagrant-proxyconf")
      config.proxy.http     = "#{http_proxy}"
      config.proxy.https    = "#{http_proxy}"
      config.proxy.no_proxy = "localhost,127.0.0.1,.example.com"
      config.apt_proxy.http  = "#{http_proxy}"
      config.apt_proxy.https = "#{http_proxy}"
  end    
  end
  
  config.vm.provision "shell" do |s|
      s.path =  "shell/vagrant-android-build.sh"
      s.args   = " #{data['network']['http_proxy_address']} #{data['network']['http_proxy_port']} "
  end
  
end
