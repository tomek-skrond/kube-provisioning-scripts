import yaml
import os

WORKDIR = os.environ['PROJECT_WORKDIR']

#TODO: Generate N 'host' entries to the yaml file as depicted in the template:
'''
vagrant:
  hosts:
    worker1:
      ansible_port: 2222
      ansible_host: 127.0.0.1
      ansible_user: vagrant
      become: true
      ansible_ssh_private_key_file: ${ID_worker1}
'''

### IT IS REQUIRED TO HAVE VAGRANT MACHINES UP AND ALL INITIAL ENVIRONMENTAL VARIABLES SET ###
how_many_machines = os.environ['HOW_MANY_MACHINES']
master_nodes = int(os.environ['MASTER_NODES'])
worker_nodes = int(os.environ['WORKER_NODES'])
master_node_name = os.environ['MASTER_NODE_VM']
worker_node_name = os.environ['WORKER_NODE_VM']



workers_names = []
masters_names = []

for i in range(worker_nodes):
    workers_names.append(
        f'{worker_node_name}{i+1}'
    )


for i in range(master_nodes):
    masters_names.append(
        f'{master_node_name}{i+1}'
    )

print("workers:", workers_names)
print("masters:",masters_names)

data = {
    'masters': {
        'hosts': {}

    },
    'workers': {
        'hosts': {}

    }
}

for machine_name in masters_names:
    port = int(os.environ[f'PORT_{machine_name}'])
    host_ip = os.environ[f'IP_{machine_name}']
    ansible_user = 'vagrant'
    ssh_id = os.environ[f'ID_{machine_name}']

    conf = {
        f'{machine_name}' : {
            'ansible_port': port,
            'ansible_host': host_ip,
            'ansible_user': ansible_user,
            'ansible_ssh_private_key_file': ssh_id,
            'become': True,
            'ansible_ssh_extra_args' : '-o StrictHostKeyChecking=no'
        }
    }

    data['masters']['hosts'].update(conf)

for machine_name in workers_names:
    port = int(os.environ[f'PORT_{machine_name}'])
    host_ip = os.environ[f'IP_{machine_name}']
    ansible_user = 'vagrant'
    ssh_id = os.environ[f'ID_{machine_name}']

    conf = {
        f'{machine_name}' : {
            'ansible_port': port,
            'ansible_host': host_ip,
            'ansible_user': ansible_user,
            'ansible_ssh_private_key_file': ssh_id,
            'become': True,
            'ansible_ssh_extra_args' : '-o StrictHostKeyChecking=no'
        }
    }

    data['workers']['hosts'].update(conf)

print("Created configuration for vagrant hosts:")
print(data)

print("SAVING AS AN INVENTORY FILE IN ansible/generated/inventory.yaml")
with open(f'{WORKDIR}/ansible/generated/inventory.yaml', 'w') as f:
    yaml.dump(data,f)
