# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

DISTRO = "centos/7"

MASTER_NODES = 1
MASTER_NODE_VM = "master"
MASTER_CPU_COUNT = 2
MASTER_MEMORY = 2048

WORKER_NODES = 2
WORKER_NODE_VM = "worker"
WORKER_CPU_COUNT = 1
WORKER_MEMORY = 2048

#### PROVISION WORKERS ####
Vagrant.configure(2) do |config|

  NodeCount = WORKER_NODES
  (1..NodeCount).each do |i|
    config.vm.define "#{WORKER_NODE_VM}#{i}" do |node|
    
      node.vm.box = "#{DISTRO}"
      node.vm.hostname = "#{WORKER_NODE_VM}#{i}.keknet.com"

#      node.vm.disk :disk, size: "#{DISK_SIZE}GB", primary: true

      node.vm.provider "virtualbox" do |vm|
        vm.name = "#{WORKER_NODE_VM}#{i}"
        vm.memory = WORKER_MEMORY
        vm.cpus = WORKER_CPU_COUNT

#        vm.customize ["modifyvm", :id, "--nic2", "hostonly", "--hostonlyadapter3", "vboxnet2"]
        vm.customize ["modifyvm", :id, "--nat-network2","keknet"]
      end
    end
  end
end


#### PROVISION MASTER NODES ####
Vagrant.configure(2) do |config|
  
  NodeCount = MASTER_NODES
  (1..NodeCount).each do |i|
    config.vm.define "#{MASTER_NODE_VM}#{i}" do |node|
      node.vm.box = "#{DISTRO}"
      node.vm.hostname = "#{MASTER_NODE_VM}#{i}.keknet.com"

#      node.vm.disk :disk, size: "#{DISK_SIZE}GB", primary: true

      node.vm.provider "virtualbox" do |vm|
        vm.name = "#{MASTER_NODE_VM}#{i}"
        vm.memory = MASTER_MEMORY
        vm.cpus = MASTER_CPU_COUNT
#        vm.disk :disk, size: "#{DISK_SIZE}GB", primary: true

#        vm.customize ["modifyvm", :id, "--nic2", "hostonly", "--hostonlyadapter3", "vboxnet2"]
        vm.customize ["modifyvm", :id,"--nat-network2","keknet"]
      end
    end
  end
end
