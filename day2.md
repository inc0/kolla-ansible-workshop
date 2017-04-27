# Day 2 operations

Kolla has some features to help with day 2 operation tasks.

# Reconfigure
To change configuration on running containers, make appropriate changes to either globals.yaml or config overrides and run
```
kolla-ansible reconfigure
```

# Upgrades
To perform release upgrade, download new version of Kolla (for example Pike when it's released) and change your globals.yaml and inventory according to change log.
Following example will not work yet because Pike hasn't been released
```
openstack_release: 5.0.0
```
After that simply run
```
kolla-ansible upgrade
```

Minor version upgrades are done in similar manner.
