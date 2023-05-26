# kube-provisioning-scripts

Vagrant + Ansible configurations and bash + Python scripts that automate provisioning of kubernetes cluster on VirtualBox.

<img src="https://www.elao.com/resized/content/images/blog/thumbnails/vagrant.png/132e0fdc7370fe435b5221b60a30ad1e.png"  width="250" height="250"> <img src="https://blog.zwindler.fr/2018/10/ansible_logo.png"  width="250" height="250"> <img src="https://logos-world.net/wp-content/uploads/2021/10/Python-Symbol.png"  width="350" height="220">


## Quick guide

**Run all provisioning commands in the working directory of scripts (where `provision.sh` is located)**

To deploy a kubernetes cluster automatically using the `provisioner` tool (`provision.sh`), enter a command:
```
$ . .env
$ ./provision.sh
```
This command reads configuration in file `.env` and provisions a cluster according to environmental variables in `.env` file.

After provisioning, you can access machines using the following command:

```
$ vagrant ssh <machine_name>
```

**For this command to work, it is required to source the `.env` file.**

If you want to customize deployments, check out the [provisioner section](https://github.com/tomek-skrond/kube-provisioning-scripts/edit/master/README.md#provisionsh).

### Project Tree

```
.
├── ansible
│   ├── config-scripts
│   │   ├── create_inventory.py
│   │   └── generate_etchosts.py
│   ├── example_inventory.yml
│   ├── generated
│   │   ├── etchosts_playbook.yaml
│   │   └── inventory.yaml
│   └── playbooks
│       ├── centos7
│       │   └── configure-kube-centos7.yml
│       └── ubuntu
├── docs
│   └── todo.md
├── provision.sh
├── README.md
├── scripts
│   ├── bootstrap.sh
│   └── discover_machines.sh
└── Vagrantfile
```
### `provision.sh`

`provisioner` runs a workflow that initiates automatic provisioning (*Vagrantfile*), creation of ansible inventory (*create_inventory.py*, *generate_etchosts.py*).

Additionally, this script is capable of altering default values for VM provisioning. Currently available modifications are:

```
$ ./provision.sh --help
Usage: ./provision.sh 
	[--master-nodes]
        	Changes quantity of master nodes deployed
	[--worker-nodes]
		Changes quantity of worker nodes deployed
    	[--worker-memory]
        	Changes amount of RAM for workers
    	[--master-memory]
        	Changes amount of RAM for master nodes
    	[--worker-cpu]
        	Changes amount of CPUs for worker nodes
    	[--master-cpu]
        	Changes amount of CPUs for master nodes
	[--network-settings]
		Set parameters for network:
			-> Network Address (ex. 10.42.11.0)
	[--destroy]
		Cleanup
```

*** BEFORE RUNNING PROVISIONING SCRIPT: ***

- Source the `.env` file (crucial for Vagrantfile to run properly)

Sample usage:
```
$ . .env
$ ./provision.sh --master-nodes 1 --worker-nodes 1 --worker-memory 1024 --master-memory 2048 --worker-cpu 1 --master-cpu 2
```


#### Vagrantfile

Provisions virtual machines according to all environmental variables exported in .env.

Before `vagrant up` (executed in the script) it is required to source .env file.

`.env` file contents:
```
#!/bin/bash

export DISTRO=centos/7

export NETWORK_ADDRESSING=10.33.1.0

export MASTER_NODES=1
export MASTER_NODE_VM=master
export MASTER_CPU_COUNT=2
export MASTER_MEMORY=2048

export WORKER_NODES=1
export WORKER_NODE_VM=worker
export WORKER_CPU_COUNT=1
export WORKER_MEMORY=1024

export PROJECT_WORKDIR=$(pwd)
```

You can change values of variables in `.env`, then the values become default.


#### `ansible/generated` Folder

Contains dynamically generated ansible inventory file (created by `create_inventory.py` and `generate_etchosts.py`).

#### `ansible/playbooks`

Holds ansible playbooks for k8s cluster configuration


### Dependencies

#### Vagrant
```
$ vagrant --version
Vagrant 2.3.4
```

#### Ruby

```
$ ruby --version
ruby 3.0.5p211 (2022-11-24 revision ba5cf0f7c5) [x86_64-linux]
```

#### Ansible

```
$ ansible --version
ansible [core 2.14.4]
  python version = 3.10.10 (main, Mar  5 2023, 22:26:53) [GCC 12.2.1 20230201] (/usr/bin/python)
  jinja version = 3.1.2
  libyaml = True
```

#### Python
```
$ python3 --version
Python 3.10.10
```

#### VirtualBox
![image](https://user-images.githubusercontent.com/58492207/235553798-edde1fd1-a8a5-4473-bde1-0170c221825c.png)
