# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

DISTRO = ENV['DISTRO']

MASTER_NODES = ENV['MASTER_NODES'].to_i
MASTER_NODE_VM = ENV['MASTER_NODE_VM']
MASTER_CPU_COUNT = ENV['MASTER_CPU_COUNT'].to_i
MASTER_MEMORY = ENV['MASTER_MEMORY'].to_i

WORKER_NODES = ENV['WORKER_NODES'].to_i
WORKER_NODE_VM = ENV['WORKER_NODE_VM']
WORKER_CPU_COUNT = ENV['WORKER_CPU_COUNT'].to_i
WORKER_MEMORY = ENV['WORKER_MEMORY'].to_i

puts WORKER_NODES

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
