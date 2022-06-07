#!/bin/bash

# Update hosts file
echo "[TASK 1] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
211.183.3.200 centos-m
211.183.3.201 centos-n1
211.183.3.202 centos-n2
211.183.3.203 centos-n3
EOF

# Enable ssh password authentication
echo "[TASK 2] Enable ssh password authentication"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Enable root ssh login
echo "[TASK 3] Enable ssh root login"
sed -i 's/.*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config

systemctl reload sshd

# Set Root password
echo "[TASK 4] Set root password"
echo root:kubeadmin | chpasswd

# Install Must Item
yum install -y vim net-tools curl wget git tree httpd

# swap off
swapoff -a
