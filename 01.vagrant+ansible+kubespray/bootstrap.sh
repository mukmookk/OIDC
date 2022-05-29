#!/bin/bash

# Update hosts file
echo "[TASK 1] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
211.183.3.137 node1
211.183.3.202 node2
211.183.3.203 node3
211.183.3.204 node4
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
