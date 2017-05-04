resource "null_resource" "ansible-provision" {
  depends_on = ["openstack_compute_floatingip_v2.controller-fip"]

  # Create list of student ip user password
  provisioner "local-exec" {
    command =  "echo \"${var.prefix} ${var.user}@${openstack_compute_floatingip_v2.controller-fip.address} ${var.password}\" >> student-info "
  }
}
