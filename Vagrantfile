# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  config.vm.define :wordpress do |wordpress|
    wordpress.vm.box = "trusty-server-cloudimg-amd64-vagrant"
    wordpress.vm.box_url = "http://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
    wordpress.vm.network :private_network, ip:  "192.168.98.10"
    #wordpress.vm.provider :virtualbox do |vb|
    #  vb.customize ["modifyvm", :id, "--memory", "512"]
    #end
  end
end
