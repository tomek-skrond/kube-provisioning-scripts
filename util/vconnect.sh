#!/bin/bash

#SCRIPT FOR CONNECTING TO VAGRANT NODE

HOST=$1

IDENTITY_FILE=$(vagrant ssh-config $HOST | grep IdentityFile | awk '{ print $2 }')
HOST_IP=$(vagrant ssh-config $HOST | grep HostName | awk '{ print $2 }')
HOST_PORT=$(vagrant ssh-config $HOST | grep Port | awk '{ print $2 }')

ssh -o StrictHostKeyChecking=no -i $IDENTITY_FILE vagrant@$HOST_IP -p $HOST_PORT
