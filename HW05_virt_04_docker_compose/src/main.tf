terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
#  service_account_key_file = "key.json"
  token = "y0_AgAAAABoV4oGAATuwQAAAADbPE1UemVIiMelQ9u0bfPMFd75PGuvMk8"
  cloud_id = var.y_cloud_id
  folder_id = var.y_folder_id
  zone = var.zone
}


resource "yandex_compute_instance" "node01" {
  name                      = "node01"
  hostname                  = "node01.netology.cloud"
  description               = "node01"
  folder_id                 = var.y_folder_id
  zone                      = var.zone
#  platform_id               = "standard-v2"

  allow_stopping_for_update = true

  resources {
    cores  = 8
#    core_fraction = 100
    memory = 8
  }

  boot_disk {
    initialize_params {
      image_id    = data.external.get_id_image.result.id
      name        = "root-node01"
      type        = "network-nvme"
      size        = "50"
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
 
resource "yandex_compute_instance" "node02" {
  name                      = "node02"
  hostname                  = "node02.netology.cloud"
  description               = "node02"
  folder_id                 = var.y_folder_id
  zone                      = var.zone

  allow_stopping_for_update = true

  resources {
    cores  = 2
    core_fraction = 100
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id    = data.external.get_id_image.result.id
      name        = "root-node02"
      type        = "network-ssd"
      size        = "50"
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



variable "y_cloud_id" {
  default = "b1g8dbhansmnljtkt5sb"
}

variable "y_folder_id" {
  default = "b1gs8f7ibom6nv7b1qnd"
}

#variable "ubuntu-2004-lts" {
#  default = data.external.get_id_image.result.value
#  default = "fd8a82hkclcfqmdo1sjb"
#}

variable "zone" {
  default = "ru-central1-a"
}

variable "subnet" {
  default = "e9bc69v1o4e97g116dqa"
}

data "external" "get_id_image" {
  program = ["bash", "./get_id.sh" ]
}
