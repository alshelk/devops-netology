
resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/prod.tftpl",
    { webservers = yandex_compute_instance.platform.network_interface[0].nat_ip_address,
      user = var.vm_metadata.ssh-user }
  )

  filename = "${abspath(path.module)}/../playbook/inventory/prod.yml"
}
