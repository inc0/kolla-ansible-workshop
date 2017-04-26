# Introduction

## What are we deploying?

This guide will walk you through deployment of multinode HA OpenStack from scrach that will resemble production environment.
We will start from 5 machines with basic Ubuntu 16.04 or Centos 7 and at the end we will (hopefully!) have our OpenStack up and running!

## Couple words about architecture

### Nodes

In Kolla we have few basic node roles:
* Controller - this node will run all control services like database, APIs, schedulers and such
* Network node - this node is dedicated for Neutron L3 agents, tunnel endpoints, DHCP agents and such. It also runs HAProxy and is connected into keepalived cluster
* Compute node - this is where VMs live. Notable services are Openvswitch, Libvirt, Nova-compute and Neutorn-l2 agents
* Storage node - this node runs Ceph OSD and Cinder agents for LVM/iscsi (in our case we will deploy Ceph)

We will work on 5 virtual machines. We will split them into these roles:
* 1 Deployment node that will also act as Controller and a Network node
* 2 Additional Controllers + Network
* 2 Shared Compute and Storage nodes (they have additional disk)


### Networking

* Every node will be hooked up to shared network 10.0.0.0/24
* Our deployment node will have routable floating IP in 192.168.202.0/24 network
* Every node will be connected to additional private network dedicated for each person
