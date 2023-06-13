
resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/hosts.tftpl",
    { webservers = [ for i in yandex_compute_instance.test : i],
      user = var.vm_metadata.ssh-user }
  )

  filename = "${abspath(path.module)}/../playbook/inventory/cicd/hosts.yml"
}
