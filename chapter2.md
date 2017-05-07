# Chapter 2 - Deploy me an OpenStack!

## Bring up rest of interfaces

For Ubuntu (also install python)
```
ansible -m raw -i multinode  -a "apt-get -y install python" all
ansible -i ./multinode -m shell -a "ifconfig ens4 up && dhclient ens4" all
ansible -i ./multinode -m shell -a "ifconfig ens5 up && dhclient ens5" all
```
For Centos (also disable selinux)
```
ansible -i ./multinode -m shell -a "ifconfig eth1 up" all
ansible -i ./multinode -m shell -a "ifconfig eth2 up && dhclient" all
ansible -i ./multinode -m shell -a "setenforce 0" all
```

## Install docker and other requirements
Let's start by installation and configuration of Docker, few packages needed by Kolla and preparation of host files.
To do that simply run
```
kolla-ansible -i ./multinode bootstrap-servers
```

## Check if everything is in order
Let's do some preflight checks
```
kolla-ansible -i ./multinode prechecks
```

## Mark disks for Ceph
We need to point which disks we want to use for Ceph deployment. To do that we need to run this command on storage nodes
```
parted $DISK -s -- mklabel gpt mkpart KOLLA_CEPH_OSD_BOOTSTRAP 1 -1
```
Or make Ansible do it!
```
ansible -i ./multinode -m shell -a "parted /dev/vdb -s -- mklabel gpt mkpart KOLLA_CEPH_OSD_BOOTSTRAP 1 -1" storage
```

## Deploy whole thing
```
kolla-ansible -i ./multinode deploy
```
