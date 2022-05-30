#!/bin/bash

sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - sudo add-apt-repository "deb [arch=amd64] \ https://download.docker.com/linux/ubuntu focal stable"
sudo apt-cache policy docker-ce
sudo apt install docker-ce –y
sudo systemctl enable docker
sudo systemctl restart docker

sudo apt-get install -y ssh
sudo systemctl enable ssh	
sudo systemctl restart ssh
sudo ufw disable

sudo swapoff -a

sudo rm /etc/containerd/config.toml
sudo systemctl restart containerd
sudo kubeadm init