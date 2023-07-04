
resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/hosts.tftpl",
    { webservers = [ yandex_compute_instance.nexus ],
      user = var.vm_metadata.ssh-user }
  )

  filename = "${abspath(path.module)}/../infrastructure/inventory/cicd/hosts.yml"
}
