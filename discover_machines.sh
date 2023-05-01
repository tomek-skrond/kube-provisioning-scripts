#!/bin/bash

echo "GATHERING MACHINE IDs"
IDENTITY_FILES=($(vagrant ssh-config | grep IdentityFile | awk '{ print $2 }'))
echo "GATHERING HOST IP"
HOST_IPS=($(vagrant ssh-config | grep HostName | awk '{ print $2 }'))
echo "GATHERING HOST PORTS"
HOST_PORTS=($(vagrant ssh-config | grep Port | awk '{ print $2 }'))
echo "GATHERING MACHINE NAMES"
HOSTS=($(vagrant ssh-config | grep -w Host | awk '{ print $2 }'))

HOW_MANY_MACHINES=$((($(vagrant ssh-config | grep -owc Host) - 1)))

echo ""
echo "......................"
echo $(($HOW_MANY_MACHINES + 1)) Machines Detected:
echo "......................"

for i in $(seq 0 $HOW_MANY_MACHINES); do

	host=${HOSTS[$i]}
	ip=${HOST_IPS[$i]}
	port=${HOST_PORTS[$i]}
	id_file=${IDENTITY_FILES[$i]}

	echo ""
	echo Host $i detected: $host
	echo "	IP: $ip"
	echo "	PORT: $port"
	echo "	IDENTITY FILE: $id_file"
	echo ""

	echo "	EXPORTING ENV (Host identity): ID_${host}"
	export ID_${host}=$id_file
	echo "	EXPORTING ENV (Host IP): IP_${host}"
	export IP_${host}=$ip
	echo "	EXPORTING ENV (Host Port): PORT_${host}"
	export PORT_${host}=$port
	echo "	EXPORTING ENV (VM name): ID_${host}"
	export HOST_${host}=$host
done

export HOW_MANY_MACHINES=$(($HOW_MANY_MACHINES + 1))
export HOSTS=$HOSTS
