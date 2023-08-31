resource "yandex_compute_instance" "test" {
  for_each = toset([ "0", "1", "2" ])
  name = "${var.list_vm_for_lesson83[each.key].vm_name}"
  platform_id   = var.vm_common_arg.platform_id
  resources {
    cores         = var.list_vm_for_lesson83[each.key].cpu
    memory        = var.list_vm_for_lesson83[each.key].ram
    core_fraction = var.list_vm_for_lesson83[each.key].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.centos.image_id
      size = var.list_vm_for_lesson83[each.key].disk
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

