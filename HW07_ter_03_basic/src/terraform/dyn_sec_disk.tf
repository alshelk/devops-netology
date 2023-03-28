resource "yandex_compute_disk" "task3-disk" {
  count      = var.vm-task3.count-disk
  name       = "${var.vm-task3.name-disk}-${count.index}"
  type       = var.vm-task3.type-disk
  zone       = var.default_zone
  size       = var.vm-task3.size-disk
}

resource "yandex_compute_instance" "vm-task3" {
  name = var.vm-task3.name
  platform_id   = var.vm-task3.platform_id
  resources {
    cores         = var.vm-task3.cores
    memory        = var.vm-task3.memory
    core_fraction = var.vm-task3.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  dynamic secondary_disk {
    for_each = yandex_compute_disk.task3-disk
    content {
      disk_id = yandex_compute_disk.task3-disk[secondary_disk.key].id
      auto_delete = var.vm-task3.auto_delete
    }
  }

  scheduling_policy {
    preemptible = var.vm-task3.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat = var.vm-task3.nat
    security_group_ids = [yandex_vpc_security_group.example.id]
  }
  metadata = {
    serial-port-enable = var.vm_metadata.serial-port-enable
    ssh-keys           = local.ssh-keys
  }
}