# Chapter 1 - Deploy a deploy node!

## Download few useful packages

Let start by installing few packages that we'll need later (use sudo or root account)

Ubuntu:
```
apt-get install python-dev libffi-dev gcc libssl-dev
pip install -U pip
```
Centos
```
yum install epel-release
yum install python-pip python-devel libffi-devel gcc openssl-devel
pip install -U pip
```
Then use pip to install Ansible and Kolla-ansible
```
pip install ansible kolla-ansible
```

## Copy configs and prepare inventory file

Example config files:

Ubuntu:
```
cp -r /usr/local/share/kolla-ansible/etc_examples/kolla /etc/kolla/
```
Centos:
```
cp -r /usr/share/kolla-ansible/etc_examples/kolla /etc/kolla/
```

Inventory files:
Ubuntu:
```
cp /usr/share/kolla-ansible/ansible/inventory/* .
```
Centos:
```
cp /usr/local/share/kolla-ansible/ansible/inventory/* .
```

## Inventory files

Next step is to prepare our inventory file. Inventory is ansible file where we specify 

