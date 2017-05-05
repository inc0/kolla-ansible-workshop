# Day 2 operations

Kolla has some features to help with day 2 operation tasks.

# Reconfigure
To change configuration on running containers, make appropriate changes to either globals.yaml or config overrides and run
```
kolla-ansible -i ./multinode reconfigure
```
It is also possible to only call only selection of roles instead whole play.  For instance if you want to just reconfigure just the haproxy
```
kolla-ansible -i ./multinode reconfigure --tags haproxy
```

# Redeploy
If modifications to the globals.yaml require additional containers to be created run a precheck after the modifications.
```
kolla-ansible -i ./multinode precheck
```
Followed by a deploy
```
kolla-ansible -i ./multinode deploy
```

# Upgrades
To perform release upgrade, download new version of Kolla (for example Pike when it's released) and change your globals.yaml and inventory according to change log.
Following example will not work yet because Pike hasn't been released
```
openstack_release: 5.0.0
```
After that simply run
```
kolla-ansible -i ./multinode upgrade
```

Minor version upgrades are done in similar manner.
