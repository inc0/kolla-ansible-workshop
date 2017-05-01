#!/bin/bash
echo "Match User ${user}" >> /etc/ssh/sshd_config
echo "  PasswordAuthentication yes" >> /etc/ssh/sshd_config
echo ${user}:${password} | /usr/sbin/chpasswd
systemctl restart sshd
