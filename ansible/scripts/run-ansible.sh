#!/bin/sh


echo "[web]" >> inventory.yml
echo "$(cd .. && cat .env | grep -oP "(?<=(WEB\=)).*")" >> inventory.yml
echo "[db]" >> inventory.yml
echo "$(cd .. && cat .env | grep -oP "(?<=(DB\=)).*")" >> inventory.yml

export ANSIBLE_HOST_KEY_CHECKING=False

ansible-playbook -v -i inventory.yml -e 'record_host_keys=True' -u ec2-user ../playbook.yml -e "db_url=$(cd .. && cat .env | grep -oP "(?<=(DB\=)).*")"
