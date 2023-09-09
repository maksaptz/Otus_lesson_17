# -*- mode: ruby -*-
# vim: set ft=ruby :
#Path to HDD on host

Vagrant.configure(2) do |config|
  config.vm.box = "debian/bullseye64"
  config.vm.box_version = "11.20230615.1"

 config.vm.define "back" do |back|
    back.vm.provider "virtualbox" do |v|
      v.memory = 512
      v.cpus = 1
      file_to_disk = './tmp/large_disk.vdi'
      v.customize ['createhd', '--filename', file_to_disk, '--size', 2 * 1024]
      v.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
    end
    back.vm.network "private_network", ip: "192.168.50.10", virtualbox__intnet: "net1"
    back.vm.hostname = "backupServer"
    back.vm.provision "shell", path: "back.sh"
  end

  config.vm.define "cl" do |cl|
    cl.vm.provider "virtualbox" do |v|
      v.memory = 512
      v.cpus = 1
    end
    cl.vm.network "private_network", ip: "192.168.50.11", virtualbox__intnet: "net1"
    cl.vm.hostname = "client"
    cl.vm.provision "shell", path: "cl.sh" 
  end
end
