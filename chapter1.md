# Chapter 1 - Deploy a deploy node!

## Download few useful packages

Let start by installing few packages that we'll need later (use sudo or root account)

Ubuntu:
```
apt-get update
apt-get install python-dev libffi-dev gcc libssl-dev python-pip
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
cp /usr/local/share/kolla-ansible/ansible/inventory/multinode .
```
Centos:
```
cp /usr/share/kolla-ansible/ansible/inventory/multinode .
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

[storage:children]
compute

[deployment]
localhost       ansible_connection=local become=true # use localhost and sudo 
```

## Prepare config files
Kolla-ansible uses 2 main config files: /etc/kolla/globals.yaml and /etc/kolla/passwords.yaml

### Generate randomized passwords
To quickly create set of randomized passwords for passwords.yaml, run

```
kolla-genpwd
```

### Prepare Kolla config
Now let's prepare actual config. Use your favorite editor to edit /etc/kolla/globals.yaml

#### Select images to deploy
In Kolla we use image-based deployment. Normally we could build our own images. Since it's time consuming task, for the purpose of training we will use pre-built images from docker registry.
If you want to learn more about building images, please refer to https://docs.openstack.org/developer/kolla/image-building.html

First we need to pick our favorite linux distributon. Currently Kolla supports Ubuntu, Centos, Oraclelinux, RHEL and Debian.
Most popular are Ubuntu and Centos. While it's theoretically possible to run mixed distro (Ubuntu host and CentOS container for example), we discourage this as it has proven to be problematic in the past.
```
kolla_base_distro: "centos"
```

After that we need to pick way our OpenStack was installed inside containers. Two options are binary and source. For CentOS both modes are proven reliable, for Ubuntu source mode seems to be more stable.
```
kolla_install_type: "source"
```
Now let's specify that we want Ocata version of OpenStack. 4.0.2 is latest released version of Kolla in Ocata.
```
openstack_release: "4.0.2"
```
And finally docker registry with images. Registry is available locally under this address
```
docker_registry: "10.0.0.6:4000"
```

#### Configure networking
Now we need to specify few details regarding our networking configuration.

First let's specify address which all internal APIs will use. This address will be managed by keepalived and HAProxy will use it for load balancing. Use address specified in handout.
```
kolla_internal_vip_address: "10.0.1.2" 
```

Now interfaces configuration. Kolla requires 2 interfaces minimum. One for control plane and another for flat network for Neutron. You can specify more interfaces for various roles, you can find more details about that here: https://docs.openstack.org/developer/kolla-ansible/production-architecture-guide.html#network-configuration
For now use networks specified in handout.
```
network_interface: "eth0"  # this is control plane, vxlan tunnels, storage and such
neutron_external_interface: "eth1"  # this is interface Neutron will use for flat external networking
```

#### Specify which services we want to deploy
Default deployment of Kolla doesn't deploy storage services. To enable them simply add
```
enable_ceph: yes
enable_cinder: yes
```

And that's it! We are ready to kick off deployment!
