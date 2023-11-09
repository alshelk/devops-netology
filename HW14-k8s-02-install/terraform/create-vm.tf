resource "yandex_compute_instance" "mnode" {
  for_each = toset(local.mnode_name)
  name = each.value
  platform_id   = var.mnode_instance.platform_id
  resources {
    cores         = var.mnode_resources.cores
    memory        = var.mnode_resources.memory
    core_fraction = var.mnode_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size = var.mnode_resources.disk
    }
  }
  scheduling_policy {
    preemptible = var.mnode_instance.scheduling_policy.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat = var.mnode_instance.network_interface.nat

  }
  metadata = {
    serial-port-enable = var.vm_metadata.serial-port-enable
    ssh-keys           = "${local.ssh-keys}"
  }
}



resource "yandex_compute_instance" "wnode" {
  for_each = toset(local.wnode_name)
  name = each.value
  platform_id   = var.wnode_instance.platform_id
  resources {
    cores         = var.wnode_resources.cores
    memory        = var.wnode_resources.memory
    core_fraction = var.wnode_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size = var.wnode_resources.disk
    }
  }
  scheduling_policy {
    preemptible = var.wnode_instance.scheduling_policy.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat = var.wnode_instance.network_interface.nat

  }
  metadata = {
    serial-port-enable = var.vm_metadata.serial-port-enable
    ssh-keys           = "${local.ssh-keys}"
  }
}