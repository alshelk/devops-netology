resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}


data "yandex_compute_image" "ubuntu" {
  #family = "ubuntu-2004-lts"
  family = var.vm_web_family
}
resource "yandex_compute_instance" "platform" {
  #name        = "netology-develop-platform-web"
  #platform_id = "standard-v1"
  name          = local.name_web
  platform_id   = var.vm_web_instance.platform_id
  resources {
    /*
    cores         = 2
    memory        = 1
    core_fraction = 5
    */
    cores         = var.vm_web_resources.cores
    memory        = var.vm_web_resources.memory
    core_fraction = var.vm_web_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    #preemptible = true
    preemptible = var.vm_web_instance.scheduling_policy.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat = var.vm_web_instance.network_interface.nat
    #nat       = true
  }

  metadata = {
    serial-port-enable = var.vm_metadata.serial-port-enable
    ssh-keys           = "${var.vm_metadata.ssh-user}:${file("~/.ssh/id_rsa.pub")}"
    #serial-port-enable = 1
    #ssh-keys           = "${var.vms_ssh_user}:${var.vms_ssh_root_key}"
  }

}

resource "yandex_compute_instance" "platform_db" {
  name          = local.name_db
  platform_id   = var.vm_db_instance.platform_id
  resources {
    cores         = var.vm_db_resources.cores
    memory        = var.vm_db_resources.memory
    core_fraction = var.vm_db_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_db_instance.scheduling_policy.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat = var.vm_db_instance.network_interface.nat
  }

  metadata = {
    serial-port-enable = var.vm_metadata.serial-port-enable
    ssh-keys           = "${var.vm_metadata.ssh-user}:${file("~/.ssh/id_rsa.pub")}"
  }

}