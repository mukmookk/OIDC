#!/bin/bash

# python fix
ls /usr/bin | grep python
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1
sudo update-alternatives --config python
python --version

# pip install and fix
sudo apt install -y python3-pip
sudo update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1
sudo update-alternatives --config pip3
pip --version

# ansible install
sudo apt install -y ansible python3-argcomplete
ansible --version

# swap unable
sudo swapoff -a

# ip forward
sudo sh -c 'echo 1 > /proc/sys/net/ipv4/ip_forward'
cat /proc/sys/net/ipv4/ip_forward