# Chapter 2 - Deploy me an OpenStack!

## Install docker and other requirements
Let's start by installation and configuration of Docker, few packages needed by Kolla and preparation of host files.
To do that simply run
```
kolla-ansible -i /path/to/our/inventory/file bootstrap-servers
```

### Check if everything is in order
Let's do some preflight checks
```
kolla-ansible -i /path/to/our/inventory/file precheck
```

### Mark disks for Ceph
We need to point which disks we want to use for Ceph deployment. To do that we need to run this command on storage nodes
```
parted $DISK -s -- mklabel gpt mkpart KOLLA_CEPH_OSD_BOOTSTRAP 1 -1
```
Or make Ansible do it!
```
ansible -i /path/to/our/inventory/file -m shell -a "parted /dev/sdb -s -- mklabel gpt mkpart KOLLA_CEPH_OSD_BOOTSTRAP 1 -1" storage
```
