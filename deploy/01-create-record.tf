resource "null_resource" "ansible-provision" {
  depends_on = ["openstack_compute_floatingip_v2.controller-fip"]

  # Create list of student ip user password
  provisioner "local-exec" {
    command =  "echo \"===${var.prefix}===\" >> student-info "
  }
  provisioner "local-exec" {
    command =  "echo \"${var.prefix} ${var.user}@${openstack_compute_floatingip_v2.controller-fip.address} ${var.password}\" >> student-info "
  }
  provisioner "local-exec" {
    command =  "echo \"${join("\n",formatlist("%s %s", openstack_compute_instance_v2.kolla-controller.*.name, openstack_compute_instance_v2.kolla-controller.*.access_ip_v4))}\" >> student-info"
  }
  provisioner "local-exec" {
    command =  "echo \"${join("\n",formatlist("%s %s", openstack_compute_instance_v2.kolla-compute.*.name, openstack_compute_instance_v2.kolla-compute.*.access_ip_v4))}\" >> student-info"
  }
  provisioner "local-exec" {
    command =  "echo \"===\\${var.prefix}===\" >> student-info "
  }
}
