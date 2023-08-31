


resource "yandex_compute_instance" "manager" {
  count = 3

  name                      = format("manager-%02d", count.index + 1)
  hostname                  = format("manager-%02d", count.index + 1)
  description               = format("manager-%02d", count.index + 1)
  folder_id                 = var.yandex_folder_id
  zone                      = var.zone
  platform_id               = "standard-v2"

  allow_stopping_for_update = true

  resources {
    cores  = 2
    core_fraction = 100
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id    = data.yandex_compute_image.ubuntu_2004.id
      type        = "network-ssd"
      size        = "30"
    }
  }

  network_interface {
    subnet_id = var.subnet
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
 
resource "yandex_compute_instance" "worker" {
  count = 3

  name                      = format("worker-%02d", count.index + 1)
  hostname                  = format("worker-%02d", count.index + 1)
  description               = format("worker-%02d", count.index + 1)
  folder_id                 = var.yandex_folder_id
  zone                      = var.zone

  allow_stopping_for_update = true

  resources {
    cores  = 2
    core_fraction = 100
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id    = data.yandex_compute_image.ubuntu_2004.id
      type        = "network-ssd"
      size        = "30"
    }
  }

  network_interface {
    subnet_id = var.subnet
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

