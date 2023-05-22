import yaml
import os
import sys
import json
import pprint as pp
from collections import OrderedDict
how_many_machines = os.environ['HOW_MANY_MACHINES']
master_nodes = int(os.environ['MASTER_NODES'])
worker_nodes = int(os.environ['WORKER_NODES'])
master_node_name = os.environ['MASTER_NODE_VM']
worker_node_name = os.environ['WORKER_NODE_VM']

subnet = sys.argv[1]

print(how_many_machines,
master_nodes,
worker_nodes, 
master_node_name,
worker_node_name,
subnet)

def create_master_conf():

    master_conf_1 = "---\n"
    master_conf_1+=f"- name: Edit /etc/hosts file\n"
    master_conf_1+=f"  hosts: masters\n"
    master_conf_1+=f"  become: true\n"
    master_conf_1+=f"  tasks:\n"

    master_conf_2 = ""

    with open('ansible/etchosts_playbook.yaml',"a") as f:
        f.write(master_conf_1)

        for i in range(worker_nodes):

            ip=f"{subnet[0:-1]}11{i+1}"
            
            master_conf_2+=f"  - name: Add an entry to /etc/hosts in {worker_node_name}{i+1}\n"
            master_conf_2+=f"    lineinfile:\n"
            master_conf_2+=f"      line: {ip}   {worker_node_name}{i+1}.example.com {worker_node_name}{i+1}\n"
            master_conf_2+=f"      path: /etc/hosts\n"
            master_conf_2+=f"      state: present\n"

        f.write(master_conf_2)

    

def create_worker_conf():

    worker_conf_1 = ""
    worker_conf_1+=f"- name: Edit /etc/hosts file\n"
    worker_conf_1+=f"  hosts: workers\n"
    worker_conf_1+=f"  become: true\n"
    worker_conf_1+=f"  tasks:\n"
    
    worker_conf_2 = ""
    
    with open('ansible/etchosts_playbook.yaml',"a") as f:
        f.write(worker_conf_1)

        for i in range(master_nodes):

            ip=f"{subnet[0:-1]}10{i+1}"

            worker_conf_2+=f"    - name: Add an entry to /etc/hosts\n"
            worker_conf_2+=f"      lineinfile:\n"
            worker_conf_2+=f"        line: {ip}   {master_node_name}{i+1}.example.com {master_node_name}{i+1}\n"
            worker_conf_2+=f"        path: /etc/hosts\n"
            worker_conf_2+=f"        state: present\n"
        
        f.write(worker_conf_2)

create_master_conf()
create_worker_conf()