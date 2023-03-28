
resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/ansible/hosts.tftpl",
    { webservers = concat(yandex_compute_instance.db, [ for i in yandex_compute_instance.web : i]) }
  )

  filename = "${abspath(path.module)}/ansible/hosts.cfg"
}
