#!/bin/bash

# make key
ssh-keygen -q -f ~/.ssh/id_rsa -N ''
cat ~/.ssh/id_rsa.pub

# ansible regist
cat >>/etc/ansible/hosts<<EOF

[all]
centos-m ansible_ssh_host=211.183.3.200 ip=211.183.3.200 ansible_user=vagrant

[master]
centos-m
EOF

# key scan
ssh-keyscan 211.183.3.142 >> ~/.ssh/known_hosts
ssh-keyscan 211.183.3.200 >> ~/.ssh/known_hosts