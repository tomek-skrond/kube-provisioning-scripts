#!/bin/bash
. .env
echo "DOWNLOADING NEEDED EXTENSIONS FOR VAGRANT"
vagrant plugin install vagrant-vbguest
echo "SETTING UP VAGRANT MACHINES"
vagrant up