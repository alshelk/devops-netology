locals {
  name_web  = "netology-${var.vpc_name}-platform-${var.vpc_role[0]}"
  name_db   = "netology-${var.vpc_name}-platform-${var.vpc_role[1]}"
  ssh-keys  = "${var.vm_metadata.ssh-user}:${file("~/.ssh/id_rsa.pub")}"
}

locals {
  servers_list = concat(yandex_compute_instance.db, [ for i in yandex_compute_instance.web : i], [yandex_compute_instance.vm-task3])
}
