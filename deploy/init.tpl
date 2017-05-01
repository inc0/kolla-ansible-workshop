#!/bin/bash

# Allow password auth for user
cat << EOF >> /etc/ssh/sshd_config

Match User ${user}
  PasswordAuthentication yes
EOF

# Change password for user
echo ${user}:${password} | /usr/sbin/chpasswd

# Reload sshd
systemctl restart sshd
