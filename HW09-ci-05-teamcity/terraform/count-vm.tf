#resource "yandex_compute_instance" "test" {
#  count = 2
#  name = "${var.vm_less9[count.index].vm_name}"
#  platform_id   = var.vm_common_arg.platform_id
#  resources {
#    cores         = "${var.vm_less9[count.index].cpu}"
#    memory        = "${var.vm_less9[count.index].ram}"
#    core_fraction = "${var.vm_less9[count.index].core_fraction}"
#  }
#  boot_disk {
#    initialize_params {
#      image_id = data.yandex_compute_image.container-optimized-image.id
#      size = "${var.vm_less9[count.index].disk}"
#    }
#  }
#  scheduling_policy {
#    preemptible = var.vm_common_arg.scheduling_policy.preemptible
#  }
#  network_interface {
#    subnet_id = yandex_vpc_subnet.training.id
#    nat = var.vm_common_arg.network_interface.nat
#
#  }
#  metadata = {
##    docker-container-declaration = file("${path.module}/cloud-terraform/${var.vm_less9[1].docker-container}")
#    docker-container-declaration = yamlencode({"spec":{"containers":[{"image":"jetbrains/${var.vm_less9[count.index].vm_name}",
#                    "env":[{"name":"SERVER_URL",
#                      "value": "http://${yandex_compute_instance.test[0].network_interface[0].nat_ip_address}:8111"}],
#                    "securityContext":{"privileged":"false"},
#                    "stdin":"false",
#                    "tty": "false"}]}})
#
##    user-data = file("${path.module}/cloud_config.yml")
#    serial-port-enable = var.vm_metadata.serial-port-enable
#    ssh-keys           = "${var.vm_metadata.ssh-user}:${file("~/.ssh/id_rsa.pub")}"
#
#  }
#
#}