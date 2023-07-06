source $(pwd)/scripts/discover_machines.sh

echo "destroyin"

vagrant destroy
rm -rf .vagrant/machines/*
sed -i '/\[127.0.0.1\]/d' ~/.ssh/known_hosts

rm $(pwd)/ansible/generated/inventory.yaml
rm $(pwd)/ansible/generated/etchosts_playbook.yaml
#vagrant global-status --prune
