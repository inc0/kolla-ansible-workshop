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

Next step is to prepare our inventory file. Inventory is ansible file where we specify node roles and access credentials.

First lines is what are interesting for us:
```
[control]
# These hostname must be resolvable from your deployment host
control01
control02
control03

# The above can also be specified as follows:
#control[01:03]     ansible_user=kolla

# The network nodes are where your l3-agent and loadbalancers will run
# This can be the same as a host in the control group
[network]
network01
network02

[compute]
compute01

[monitoring]
monitoring01

# When compute nodes and control nodes use different interfaces,
# you can specify "api_interface" and other interfaces like below:
#compute01 neutron_external_interface=eth0 api_interface=em1 storage_interface=em1 tunnel_interface=em1

[storage]
storage01

[deployment]
localhost       ansible_connection=local
```

Our job now is to populate all the groups ([control] is a group for example) with credentials of machines

Let's edit this file so it will look roughly like this (with our environment credentials)
```
[control]
10.0.0.[10:12] ansible_user=ubuntu ansible_password=foobar ansible_become=true # Ansible supports syntax like [10:12] - that means 10, 11 and 12. Become clausule means "use sudo"

[network:children]
control   # when you specify group_name:children, it will use contents of group specified

[compute]
10.0.0.[13:14] ansible_user=ubuntu ansible_password=foobar 

[monitoring]
10.0.0.10  # this group is for monitoring node. We will not deploy monitoring today as it's not production ready. We need to fill it nonetheless. Use one controller

# When compute nodes and control nodes use different interfaces,
# you can specify "api_interface" and other interfaces like below:
#compute01 neutron_external_interface=eth0 api_interface=em1 storage_interface=em1 tunnel_interface=em1

[storage:children]
compute

[deployment]
localhost       ansible_connection=local become=true # use localhost and sudo 
```

