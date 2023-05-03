# kube-provisioning-scripts

Vagrant + Ansible configurations and bash scripts that automate provisioning of kubernetes cluster on VirtualBox

### Project Tree

```
.
├── ansible
│   ├── example_inventory.yml
│   └── inventory.yaml
└── playbooks
│       ├── centos7
│       │   └── configure-kube-centos7.yml
│       └── ubuntu
├── create_inventory.py
├── discover_machines.sh
├── provision.sh
├── README.md
├── .env
├── .env.old
├── util
│   ├── clear_known_hosts.sh
│   └── vconnect.sh
└── Vagrantfile
```

#### `ansible/` Folder

Contains dynamically generated ansible inventory file (created by `create_inventory.py`).

#### `ansible/playbooks`

Holds ansible playbooks for k8s cluster configuration

#### `util/` Folder

Contains utility scripts that help with smoother debugging/development experience.

`clear_known_hosts.sh` -> 'one liner' that removes all host keys in known_hosts that have `[127.0.0.1]` tag. 
`vconnect.sh` -> used to connect to specified node (as an argument) deployed by vagrant

Usage:
```
$ ./vconnect.sh host1
[vagrant@localhost]$
```

#### Vagrantfile

Provisions virtual machines according to all environmental variables exported in .env.

Before `vagrant up` (executed in the script) it is required to source .env file.

`.env` file contents:
```
#!/bin/bash

export DISTRO=centos/7

export MASTER_NODES=1
export MASTER_NODE_VM=master
export MASTER_CPU_COUNT=2
export MASTER_MEMORY=2048

export WORKER_NODES=4
export WORKER_NODE_VM=worker
export WORKER_CPU_COUNT=1
export WORKER_MEMORY=1024
```

You can change values of variables in `.env`, then the values become default.

#### `provision.sh`

`provisioner` runs a workflow that initiates automatic provisioning (*Vagrantfile*), creation of ansible inventory (*create_inventory.py*).

Additionally, this script is capable of altering default values for VM provisioning. Currently available modifications are:

```
    [-m|--master-nodes]
        Changes quantity of master nodes deployed
    [-w|--worker-nodes]
        Changes quantity of worker nodes deployed
    [-wm|--worker-memory]
        Changes amount of RAM for workers
    [-mm|--master-memory]
        Changes amount of RAM for master nodes
    [-wc|--worker-cpu]
        Changes amount of CPUs for worker nodes
    [-mc|--master-cpu]
        Changes amount of CPUs for master nodes

```

*** BEFORE RUNNING PROVISIONING SCRIPT: ***

- Source the `.env` file (crucial for Vagrantfile to run properly)

Sample usage:
`
$ . .env
$ ./provision.sh --master-nodes 1 --worker-nodes 1 --worker-memory 1024 --master-memory 2048 --worker-cpu 1 --master-cpu 2`



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
