
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

resource "yandex_compute_instance_group" "ig-1" {
  name               = "ig-lamp"
  folder_id          = var.folder_id
  service_account_id = "${yandex_iam_service_account.sa.id}"
  deletion_protection = "false"
  instance_template {
    platform_id = "standard-v3"
    resources {
      memory = var.vm_resources.memory
      cores  = var.vm_resources.cores
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = var.lamp_ig_id
      }
    }

    network_interface {
      network_id = "${yandex_vpc_network.my-vpc.id}"
      subnet_ids = ["${yandex_vpc_subnet.public.id}"]
    }

    metadata = {
      ssh-keys = "${local.ssh-keys}"

      user-data = <<-EOF
      #!/bin/bash
      echo '<!doctype html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><title>My picture</title></head><body><h1>ссылка на картинку</h1><img src="https://${yandex_storage_bucket.bucket.bucket_domain_name}/${yandex_storage_object.my_store.key}" alt="picture"></body> </html>' > /var/www/html/index.html

      EOF
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

#   scale_policy {
#     auto_scale {
#       initial_size           = 3
#       measurement_duration   = 60
#       cpu_utilization_target = 75
#       min_zone_size          = 3
#       max_size               = 15
#       warmup_duration        = 60
#       stabilization_duration = 120
#     }
#   }

  allocation_policy {
    zones = [var.default_zone]
  }

  health_check {
    http_options {
      port = 80
      path = "/index.html"
    }
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }



  load_balancer {
    target_group_name        = "target-group"
    target_group_description = "load balancer target group"
  }
}

resource "yandex_compute_instance_group" "ig-2" {
  name               = "ig2-lamp"
  folder_id          = var.folder_id
  service_account_id = "${yandex_iam_service_account.sa.id}"
  deletion_protection = "false"
  instance_template {
    platform_id = "standard-v3"
    resources {
      memory = var.vm_resources.memory
      cores  = var.vm_resources.cores
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = var.lamp_ig_id
      }
    }

    network_interface {
      network_id = "${yandex_vpc_network.my-vpc.id}"
      subnet_ids = ["${yandex_vpc_subnet.public.id}"]
    }

    metadata = {
      ssh-keys = "${local.ssh-keys}"

      user-data = <<-EOF
      #!/bin/bash
      echo '<!doctype html><html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><title>My picture</title></head><body><h1>ссылка на картинку №2</h1><img src="https://${yandex_storage_bucket.bucket.bucket_domain_name}/${yandex_storage_object.my_store.key}" alt="picture"></body> </html>' > /var/www/html/index.html

      EOF
    }
  }

  scale_policy {
    fixed_scale {
      size = 2
    }
  }

  allocation_policy {
    zones = [var.default_zone]
  }

  health_check {
    http_options {
      port = 80
      path = "/index.html"
    }
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }



  application_load_balancer {
    target_group_name        = "target-group2"
    target_group_description = "application load balancer target group"
  }
}
