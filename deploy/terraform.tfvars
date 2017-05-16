# Base label for created resources
prefix="student"

# Number of controller nodes
controller-count="3"

# Number of compute nodes
node-count="2"

# Private network for instances
internal-ip-pool="demo-net"

# Public network floating IPs will be attached to 
floating-ip-pool="public1"

# Image properties for all instances
image-name="ubuntu-16.04"
image-flavor="m1.large"

# sec groups for all instances
security-groups="default"

# key-pair name in openstack
key-pair="workshop"

# private key to be added to each instance
private-key-file="/home/test/.ssh/workshop"
