ENV['VAGRANT_NO_PARALLEL'] = 'yes'

DISTRO = ENV['DISTRO']

### FOR EXAMPLE: keknet.com
LOCAL_SUBDOMAIN = ENV['LOCAL_SUBDOMAIN']
### FULL DOMAIN = MASTER_NODE_VM + LOCAL_SUBDOMAIN
### Example: master1.keknet.com
### Example: worker1.keknet.local.com

MASTER_NODES = ENV['MASTER_NODES'].to_i
MASTER_NODE_VM = ENV['MASTER_NODE_VM']
MASTER_CPU_COUNT = ENV['MASTER_CPU_COUNT'].to_i
MASTER_MEMORY = ENV['MASTER_MEMORY'].to_i

WORKER_NODES = ENV['WORKER_NODES'].to_i
WORKER_NODE_VM = ENV['WORKER_NODE_VM']
WORKER_CPU_COUNT = ENV['WORKER_CPU_COUNT'].to_i
WORKER_MEMORY = ENV['WORKER_MEMORY'].to_i

NETWORK_ADDRESSING = ENV['NETWORK_ADDRESSING']

ADDRESSING = NETWORK_ADDRESSING.dup
last = NETWORK_ADDRESSING[-1].dup

while last != '.'
    ADDRESSING.chop!
    last = ADDRESSING[-1]
end


Vagrant.configure(2) do |config|

    config.vbguest.auto_update = false
    config.vbguest.installer_hooks[:before_install] = ["yum -y install bzip2 elfutils-libelf-devel gcc kernel-devel kernel-headers make perl tar", "sleep 2"]
    config.vm.provision "shell", path: "scripts/bootstrap.sh"


    (1..MASTER_NODES).each do |i|
  
      config.vm.define "#{MASTER_NODE_VM}#{i}" do |node|
  
        node.vm.box               = DISTRO
        node.vm.box_check_update  = false
        #node.vm.box_version       = DISTRO_VERSION
        node.vm.hostname          = "#{MASTER_NODE_VM}#{i}.example.com"
  
        node.vm.network "private_network", ip: "#{ADDRESSING}10#{i}"
          
        node.vm.provider :virtualbox do |v|
          v.name    = "master#{i}"
          v.memory  = MASTER_MEMORY
          v.cpus    = MASTER_CPU_COUNT
        end

      end
  
    end
  
    (1..WORKER_NODES).each do |i|
  
      config.vm.define "#{WORKER_NODE_VM}#{i}" do |node|
  
        node.vm.box               = DISTRO
        node.vm.box_check_update  = false
        #node.vm.box_version       = DISTRO_VERSION
        node.vm.hostname          = "#{WORKER_NODE_VM}#{i}.example.com"
  
        node.vm.network "private_network", ip: "#{ADDRESSING}11#{i}"
  
        node.vm.provider :virtualbox do |v|
          v.name    = "worker#{i}"
          v.memory  = WORKER_MEMORY
          v.cpus    = WORKER_CPU_COUNT
        end
  
      end
  
    end
end
