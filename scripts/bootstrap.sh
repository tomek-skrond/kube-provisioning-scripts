#!/bin/bash

# Enable ssh password authentication
echo "Enable ssh password authentication"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/.*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -ie 's/^#MaxAuthTries.*/MaxAuthTries 20/g' /etc/ssh/sshd_config
systemctl reload sshd

# Set Root password
#echo "Set root password"
#echo -e "vagrant" | passwd root >/dev/null 2>&1