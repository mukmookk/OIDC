#!/bin/bash

yum install -y ansible
ssh-keygen -q -f ~/.ssh/id_rsa -N ''
git clone https://github.com/kubernetes-sigs/kubespray.git

ssh-keyscan 211.183.3.200 >> ~/.ssh/known_hosts
ssh-keyscan 211.183.3.201 >> ~/.ssh/known_hosts
ssh-keyscan 211.183.3.202 >> ~/.ssh/known_hosts
ssh-keyscan 211.183.3.203 >> ~/.ssh/known_hosts