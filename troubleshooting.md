# Troubleshooting in containers

Since all services runs inside container, slightly different approach to troubleshoot has to be taken.

## Getting logs

First step is looking at logs. There are few places to look:

```
docker logs
```
This command will print out stdout of service. Usually it will help with breakages that happens before service is properly started and starts to use regular log file

Kolla creates shared volume on host that is mounted to /var/log/kolla in containers (also all services are configured to use this dir).
Contents of this volume can be found in
```
/var/lib/docker/volumes/kolla_logs/_data
```

## Check status of container
To see if services are even running use command
```
docker ps -a
```

If container is in Exited or Restarting state, that usually means trouble.

## Exec into container
To run a command inside container use docker exec command. For example to run shell in nova_compute container use
```
docker exec -it nova_compute bash
```

Since Kolla runs all services with underprivileged users inside container, and container distros lack good debugging tools (like vim), you might need to install them. 
To that you need to exec with root user
```
docker exec -it -u root nova_compute bash
```

## Networking
Since all Kolla containers are run with net=host, whole networking stack will be the same as on host and all networking tools will be relevant.
Only exception is openvswitch container, where, while low level bridges are run in kernel, toolset to control ovs is only available inside container, use 
```
docker exec -it openvswitch-vswitchd ovs-vscl show
```

## Central logging
Kolla comes with ELK (or rather, EFK:)) stack. That is Elastic search + Fluentd + Kibana. To enable deployment of this software make this change to globals.yaml
```
enable_central_logging: yes
```
Also, if you want to deploy your OpenStack with debug enabled. Careful, if you enable both it will quickly consume a lot of disk space.
```
enable_debug_logging: yes
```

### When all hope is lost, destroy and redeploy
Since Kolla doesn't really touch host that much, it's easy to wipe out your existing env, in fact we have command for that!
```
kolla-ansible -i multinode destroy --yes-i-really-really-mean-it
```

