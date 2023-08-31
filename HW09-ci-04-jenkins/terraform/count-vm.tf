resource "yandex_compute_instance" "test" {
  count = 2
  name = "${var.vm_less9.vm_name[count.index]}"
  platform_id   = var.vm_common_arg.platform_id
  resources {
    cores         = var.vm_less9.cpu
    memory        = var.vm_less9.ram
    core_fraction = var.vm_less9.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.centos.image_id
      size = var.vm_less9.disk
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
    ssh-keys           = "${var.vm_metadata.ssh-user}:${file("~/.ssh/id_rsa.pub")}"

  }
}