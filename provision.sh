#!/bin/bash

source .env

echo "INITIAL CONFIGURATION FILE CONTENTS:"
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
cat .env
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo ""
echo ""

usage(){
  echo "Usage: $0 "
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    h)
	    usage
	    exit 0
	    ;;
    -m|--master-nodes)
	MASTER_NODES=$2
	echo master-node number set to $MASTER_NODES
	shift 2
	;;
    -w|--worker-nodes)
	WORKER_NODES=$2
	echo worker-node number set to $WORKER_NODES
	shift 2
	;;
    -wm|--worker-memory)
	WORKER_MEMORY=$2
	echo worker node memory set to $WORKER_MEMORY
	shift 2
	;;
    -mm|--master-memory)
	MASTER_MEMORY=$2
	echo master node memory set to $MASTER_MEMORY
	shift 2
	;;
    -wc|--worker-cpu)
	WORKER_CPU_COUNT=$2
	echo worker node cpu count set to $WORKER_CPU_COUNT
	shift 2
	;;
    -mc|--master-cpu)
	MASTER_CPU_COUNT=$2
	echo master node cpu count set to $WORKER_CPU_COUNT
	shift 2
	;;
    *)
      echo "Unknown argument"
      usage
      exit 1
      ;;
  esac
done

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
