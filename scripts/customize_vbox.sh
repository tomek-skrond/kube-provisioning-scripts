#!/bin/bash
# This script allows virtualbox to use virtual networks other than default (192.168.0.0/24

/bin/bash -lc 'mkdir -p /etc/vbox/ && echo "* 0.0.0.0/0 ::/0" > /etc/vbox/networks.conf'
