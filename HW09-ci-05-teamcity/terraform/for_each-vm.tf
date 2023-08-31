resource "yandex_compute_instance" "server" {
#  count = 2
  name = "${var.vm_less9[0].vm_name}-01"
  platform_id   = var.vm_common_arg.platform_id
  resources {
    cores         = "${var.vm_less9[0].cpu}"
    memory        = "${var.vm_less9[0].ram}"
    core_fraction = "${var.vm_less9[0].core_fraction}"
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.container-optimized-image.id
      size = "${var.vm_less9[0].disk}"
    }
  }
  scheduling_policy {
    preemptible = var.vm_common_arg.scheduling_policy.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.training.id
    nat = var.vm_common_arg.network_interface.nat

  }
  metadata = {
    docker-container-declaration = file("${path.module}/cloud-terraform/${var.vm_less9[0].docker-container}")
#    user-data = file("${path.module}/cloud_config.yml")
    serial-port-enable = var.vm_metadata.serial-port-enable
    ssh-keys           = "${var.vm_metadata.ssh-user}:${file("~/.ssh/id_rsa.pub")}"

  }


}

resource "yandex_compute_instance" "agent" {

  name = "${var.vm_less9[1].vm_name}-01"
  platform_id   = var.vm_common_arg.platform_id
  resources {
    cores         = "${var.vm_less9[1].cpu}"
    memory        = "${var.vm_less9[1].ram}"
    core_fraction = "${var.vm_less9[1].core_fraction}"
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.container-optimized-image.id
      size = "${var.vm_less9[1].disk}"
    }
  }
  scheduling_policy {
    preemptible = var.vm_common_arg.scheduling_policy.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.training.id
    nat = var.vm_common_arg.network_interface.nat

  }
  metadata = {
    docker-container-declaration = yamlencode({spec:{containers:[{"image":"jetbrains/teamcity-agent",
                    "env":[{"name":"SERVER_URL",
                      "value": "http://${yandex_compute_instance.server.network_interface[0].nat_ip_address}:8111"}],
                    "securityContext":{"privileged":"false"},
                    "stdin":"false",
                    "tty": "false"}]}})

    serial-port-enable = var.vm_metadata.serial-port-enable
    ssh-keys           = "${var.vm_metadata.ssh-user}:${file("~/.ssh/id_rsa.pub")}"

  }

   depends_on = [yandex_compute_instance.server]
}

resource "yandex_compute_instance" "nexus" {

  name = "${var.nexus.vm_name}-01"
  platform_id   = var.vm_common_arg.platform_id
  resources {
    cores         = "${var.nexus.cpu}"
    memory        = "${var.nexus.ram}"
    core_fraction = "${var.nexus.core_fraction}"
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.centos.image_id
      size = "${var.nexus.disk}"
    }
  }
  scheduling_policy {
    preemptible = var.vm_common_arg.scheduling_policy.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.training.id
    nat = var.vm_common_arg.network_interface.nat
  }
  metadata = {
    serial-port-enable = var.vm_metadata.serial-port-enable
    ssh-keys           = "centos:${file("~/.ssh/id_rsa.pub")}"

  }

}