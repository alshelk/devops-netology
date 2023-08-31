resource "yandex_vpc_network" "training" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "training" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.training.id
  v4_cidr_blocks = var.default_cidr
}

data "yandex_compute_image" "centos" {
  family = var.vm_web_family
}

resource "yandex_compute_instance" "platform" {
  name          = local.name_clickhouse
  platform_id   = var.vm_clickhouse_instance.platform_id
  resources {
    cores         = var.vm_clickhouse_resources.cores
    memory        = var.vm_clickhouse_resources.memory
    core_fraction = var.vm_clickhouse_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.centos.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_clickhouse_instance.scheduling_policy.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.training.id
    nat = var.vm_clickhouse_instance.network_interface.nat
  }

  metadata = {
    serial-port-enable = var.vm_metadata.serial-port-enable
    ssh-keys           = "${var.vm_metadata.ssh-user}:${file("~/.ssh/id_rsa.pub")}"
  }

}
