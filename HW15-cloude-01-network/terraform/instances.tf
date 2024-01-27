
resource "yandex_compute_instance" "nat_instance" {
  name        = var.vm_nat_name
  platform_id = "standard-v3"
  zone        = var.default_zone

  resources {
    core_fraction = var.vm_resources.core_fraction
    cores         = var.vm_resources.cores
    memory        = var.vm_resources.memory
  }

  boot_disk {
    initialize_params {
      image_id = var.nat_instance_id
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    ip_address         = "192.168.10.254"
    nat                = true
  }

  metadata = {
    user-data = "#cloud-config\nusers:\n  - name: ${var.ssh_user}\n    groups: sudo\n    shell: /bin/bash\n    sudo: ['ALL=(ALL) NOPASSWD:ALL']\n    ssh-authorized-keys:\n      - ${file("~/.ssh/id_rsa.pub")}"
  }
}

data "yandex_compute_image" "ubuntu" {
  family = var.vm_family
}

resource "yandex_compute_instance" "test_vm_public" {
  name = var.test_vm_instance.name
  platform_id   = var.test_vm_instance.platform_id
  hostname = var.test_vm_instance.name
  resources {
    cores         = var.vm_resources.cores
    memory        = var.vm_resources.memory
    core_fraction = var.vm_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size = var.vm_resources.disk
    }
  }
  scheduling_policy {
    preemptible = var.test_vm_instance.scheduling_policy.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat = var.test_vm_instance.network_interface.nat

  }
  metadata = {
    serial-port-enable = var.test_vm_instance.serial_port_enable
    ssh-keys           = "${local.ssh-keys}"
  }
}

resource "yandex_compute_instance" "test_vm_private" {
  name = var.test_vm_instance2.name
  platform_id   = var.test_vm_instance2.platform_id
  hostname = var.test_vm_instance2.name
  resources {
    cores         = var.vm_resources.cores
    memory        = var.vm_resources.memory
    core_fraction = var.vm_resources.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size = var.vm_resources.disk
    }
  }
  scheduling_policy {
    preemptible = var.test_vm_instance2.scheduling_policy.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
    nat = var.test_vm_instance2.network_interface.nat

  }
  metadata = {
    serial-port-enable = var.test_vm_instance.serial_port_enable
    ssh-keys           = "${local.ssh-keys}"
  }
}

