import yaml
import os

how_many_machines = os.environ['HOW_MANY_MACHINES']
master_nodes = int(os.environ['MASTER_NODES'])
worker_nodes = int(os.environ['WORKER_NODES'])
master_node_name = os.environ['MASTER_NODE_VM']
worker_node_name = os.environ['WORKER_NODE_VM']


data = {
    'masters': {
        'hosts': {}

    },
    'workers': {
        'hosts': {}

    }

}
