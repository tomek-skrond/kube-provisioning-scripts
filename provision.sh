#!/bin/bash


initial_config(){
	echo "INITIAL CONFIGURATION FILE CONTENT:"
	echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
	cat .env
	echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
	echo ""
	echo ""
}

usage(){
  echo "Usage: $0 "
  echo "	[-m|--master-nodes]
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
	[-n|--network-settings]
		Set parameters for network (only NETWORK available):
			-> Network Name (ex. NETWORK2137)
			-> Nat Network Address (ex. 192.168.12.0)
			-> CIDR Subnet Mask (ex. 24)
	[-d|--destroy]
		Cleanup"
}

vagrant_up(){
	echo "SETTING UP VAGRANT MACHINES"
	vagrant up
}

build_ansible_config(){
	python3 create_inventory.py
}

check_ansible_hosts(){
	echo "CHECKING ANSIBLE HOSTS"
	ansible -m ping all -i ansible/inventory.yaml
}

provision_vbox_network(){
	echo "network provisioning"
	echo Shutting down vms

	for machine in ${HOSTS[@]}; do
		#VBoxManage controlvm $machine poweroff
		ansible $machine -m shell -a 'sudo /sbin/shutdown -h now' -i ansible/inventory.yaml
	done

	echo "Waiting for VMs to shut down completely"
	sleep 10
	
	if [[ "$NETWORK_TYPE" == "natnetwork" ]]; then
		VBoxManage natnetwork add --netname $NETWORK_NAME --network "$NETWORK_ADDRESSING/$NETWORK_SUBNET_MASK" --enable
		VBoxManage natnetwork start --netname $NETWORK_NAME
		VBoxManage natnetwork modify --netname $NETWORK_NAME --dhcp on
		
		for machine in ${HOSTS[@]};do
			VBoxManage modifyvm $machine --nic2 natnetwork --nat-network2 $NETWORK_NAME
			VBoxManage modifyvm $machine --nic2 natnetwork --nat-network2 $NETWORK_NAME
		done
	fi

	if [[ "$NETWORK_TYPE" == "hostonly" ]]; then
		echo "hostonly - not implemented"
	fi

	for machine in ${HOSTS[@]}; do
		VBoxManage startvm $machine
	done
}

destroy(){
	source discover_machines.sh
	
	vagrant destroy
	rm -rf .vagrant/machines/*
	/bin/bash -lc "$(pwd)/util/clear_known_hosts.sh"

	echo "REMOVING ADDITIONAL NETWORKS"
	if [[ "$NETWORK_TYPE" == "natnetwork" ]]; then
		VBoxManage natnetwork remove --netname $NETWORK_NAME
	fi
	rm $(pwd)/ansible/inventory.yaml
	vagrant global-status --prune
	exit 0
}


cat .env > .env.old

while [[ $# -gt 0 ]]; do
  case "$1" in
    h|--help)
	    usage
	    exit 0
	    ;;
    -m|--master-nodes)
	sed -i 's/MASTER_NODES=[0-9]*/MASTER_NODES\='"$2"'/g' .env
	export MASTER_NODES=$2
	echo master-node number set to $MASTER_NODES
	shift 2
	;;
    -w|--worker-nodes)
	sed -i 's/WORKER_NODES=[0-9]*/WORKER_NODES\='"$2"'/g' .env
	export WORKER_NODES=$2
	echo worker-node number set to $WORKER_NODES
	shift 2
	;;
    -wm|--worker-memory)
	sed -i 's/WORKER_MEMORY=[0-9]*/WORKER_MEMORY\='"$2"'/g' .env
	export WORKER_MEMORY=$2
	echo worker node memory set to $WORKER_MEMORY
	shift 2
	;;
    -mm|--master-memory)
	sed -i 's/WORKER_MEMORY=[0-9]*/WORKER_MEMORY\='"$2"'/g' .env
	export MASTER_MEMORY=$2
	echo master node memory set to $MASTER_MEMORY
	shift 2
	;;
    -wc|--worker-cpu)
	sed -i 's/WORKER_CPU_COUNT=[0-9]*/WORKER_CPU_COUNT\='"$2"'/g' .env
	export WORKER_CPU_COUNT=$2
	echo worker node cpu count set to $WORKER_CPU_COUNT
	shift 2
	;;
    -mc|--master-cpu)
	sed -i 's/MASTER_CPU_COUNT=[0-9]*/MASTER_CPU_COUNT\='"$2"'/g' .env
	export MASTER_CPU_COUNT=$2
	echo master node cpu count set to $WORKER_CPU_COUNT
	shift 2
	;;
    -n|--network-settings)
	sed -i 's/NETWORK_NAME=[Aa-Zz]*/NETWORK_NAME\='"$2"'/g' .env
	sed -i -E 's/NETWORK_ADDRESSING=[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/NETWORK_ADDRESSING='"$3"'/g' .env
	sed -i 's/NETWORK_SUBNET_MASK=[0-9]*/NETWORK_SUBNET_MASK\='"$4"'/g' .env
	export NETWORK_NAME=$2
	export NETWORK_ADDRESSING=$3
	export NETWORK_SUBNET_MASK=$4
	shift 4
	;;
    -d|--destroy)
	destroy
	shift 2
	;;
    *)
	echo "Unknown argument"
    	usage
    	exit 1
	;;
  esac
done

echo "DIFFERENCE BETWEEN INITIAL CONFIG"
diff .env .env.old

#source .env file for initial variables
source .env

initial_config

echo PROVISIONING PARAMETERS:
echo ""
echo "----------------------"
echo MASTER NODE:
echo "----------------------"

echo MASTER_NODES: $MASTER_NODES
echo MASTER_NODE_VM: $MASTER_NODE_VM
echo MASTER_CPU_COUNT: $MASTER_CPU_COUNT
echo MASTER_MEMORY: $MASTER_MEMORY

echo ""
echo "----------------------"
echo WORKER NODE:
echo "----------------------"

echo WORKER_NODES: $WORKER_NODES
echo WORKER_NODE_VM: $WORKER_NODE_VM
echo WORKER_CPU_COUNT: $WORKER_CPU_COUNT
echo WORKER_MEMORY: $WORKER_MEMORY

#provision machines using vagrant
vagrant_up
#get information about provisioned machines
#generate env variables for ansible inventory creation
source discover_machines.sh
#build ansible inventory
build_ansible_config
#test availability of machines
check_ansible_hosts
#incorporate additional networks to machines
provision_vbox_network
#run ansible playbook (install and configure Kubernetes on all nodes, playbooks path: ansible/playbooks/[DISTRO]/)
#echo Distribution: $DISTRO
#distro_fmt=$(echo $DISTRO)
#ansible-playbook ansible/playbooks/
