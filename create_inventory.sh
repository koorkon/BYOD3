#!/bin/bash
IP=$(cat aws_hosts)

echo "[grafana_servers]" > aws_hosts
echo "$IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa_project" >> aws_hosts
