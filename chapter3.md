# Let's use our OpenStack

Now that everything is deployed, we can start using our OpenStack

## Generate admin_openrc
To quickly prepare openrc file for OpenStack run
```
kolla-ansible post-deploy
source /etc/kolla/admin-openrc.sh
```

## Install OpenStack clients
```
pip install python-openstackclient python-glanceclient python-neutronclient
```

## Boostrap some flavors, images and networks
Centos
```
cd /usr/share/kolla-ansible
./init-runonce
```
Ubuntu
```
cd /usr/local/share/kolla-ansible
./init-runonce
```

## Spawn a vm
init-runonce will prepare us a command to spawn our first vm, let's use it! :)
