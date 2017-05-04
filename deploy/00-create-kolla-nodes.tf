# Setup needed variables
variable "prefix" {
  default = "student"
}
variable "controller-count" {
  default = 3
}
variable "node-count" {
  default = 2
}
variable "internal-ip-pool" {}
variable "floating-ip-pool" {}
variable "image-flavor" {}
variable "security-groups" {}
variable "key-pair" {}
variable "private-key-file" {
  default = "/root/.ssh/id_rsa"
}
variable "os" {
  default = "ubuntu"
}
variable "user" {
  default = "ubuntu"
}
variable "password" {
  default = "kolla"
}
variable "volume-size" {
  default = "15"
}

# Create template for user data
data "template_file" "user_data" {
  template = "${file("${path.module}/init.tpl")}"
  vars {
    user     = "${var.user}"
    password = "${var.password}"
  }
}

# Image references
data "openstack_images_image_v2" "ubuntu" {
  name = "ubuntu-16.04"
  most_recent = true
}
data "openstack_images_image_v2" "centos" {
  name = "centos7"
  most_recent = true
}

# Hack to use interpolated variables. Doesnt matter here but changing a trigger causes a re-provisioning.
resource "null_resource" "ref" {
    triggers = {
      image-id = "${var.os == "ubuntu" ?  data.openstack_images_image_v2.ubuntu.id : data.openstack_images_image_v2.centos.id}"
    }
}

# Create control network
resource "openstack_networking_network_v2" "network-control" {
  name           = "${var.prefix}-control-net"
  admin_state_up = "true"
}

# Create data network
resource "openstack_networking_network_v2" "network-data" {
  name           = "${var.prefix}-data-net"
  admin_state_up = "true"
}

# Create control subnet
resource "openstack_networking_subnet_v2" "subnet-control" {
  name       = "${var.prefix}-control-subnet"
  network_id = "${openstack_networking_network_v2.network-control.id}"
  cidr       = "10.1.0.0/24"
  ip_version = 4
}

# Create data subnet
resource "openstack_networking_subnet_v2" "subnet-data" {
  name       = "${var.prefix}-data-subnet"
  network_id = "${openstack_networking_network_v2.network-data.id}"
  cidr       = "10.1.1.0/24"
  ip_version = 4
}

# Create n controllers
resource "openstack_compute_instance_v2" "kolla-controller" {
  count = "${var.controller-count}"
  name = "${var.prefix}-kolla-controller-${count.index}"
  image_id = "${null_resource.ref.triggers.image-id}"
  flavor_name = "${var.image-flavor}"
  key_pair = "${var.key-pair}"
  security_groups = ["${split(",", var.security-groups)}"]
  network {
    name = "${var.internal-ip-pool}"
  }
  network {
     uuid = "${openstack_networking_network_v2.network-control.id}"
  }

  network {
     uuid = "${openstack_networking_network_v2.network-data.id}"
  }
  user_data = "${data.template_file.user_data.rendered}"
}

# Create floating IP
resource "openstack_compute_floatingip_v2" "controller-fip" {
  pool = "${var.floating-ip-pool}"
}

# Associate floating IP to first controller
resource "openstack_compute_floatingip_associate_v2" "controller-fip" {
  floating_ip = "${openstack_compute_floatingip_v2.controller-fip.address}"
  instance_id = "${openstack_compute_instance_v2.kolla-controller.0.id}"
  fixed_ip = "${openstack_compute_instance_v2.kolla-controller.0.network.0.fixed_ip_v4}"
}

# Create y number of nodes
resource "openstack_compute_instance_v2" "kolla-compute" {
  count = "${var.node-count}"
  name = "${var.prefix}-kolla-compute-${count.index}"
  image_id = "${null_resource.ref.triggers.image-id}"
  flavor_name = "${var.image-flavor}"
  key_pair = "${var.key-pair}"
  security_groups = ["${split(",", var.security-groups)}"]
  network {
    name = "${var.internal-ip-pool}"
  }
  network {
     uuid = "${openstack_networking_network_v2.network-control.id}"
  }

  network {
     uuid = "${openstack_networking_network_v2.network-data.id}"
  }
  block_device {
    source_type           = "image"
    uuid                  = "${null_resource.ref.triggers.image-id}"
    destination_type      = "local"
    boot_index            = 0
    delete_on_termination = true
  }

  block_device {
    source_type           = "blank"
    destination_type      = "volume"
    volume_size           = "${var.volume-size}"
    boot_index            = 1
    delete_on_termination = true
  }

  user_data = "${data.template_file.user_data.rendered}"
}
output "name" {
  value = "${var.prefix}"
}
output "ip" {
  value = "${openstack_compute_floatingip_v2.controller-fip.address}"
}
output "login" {
  value = "${var.user}"
}
output "password" {
  value = "${var.password}"
}
output "ssh" {
  value = "ssh -i ~/.ssh/workshop ${var.user}@${openstack_compute_floatingip_v2.controller-fip.address}"
}
