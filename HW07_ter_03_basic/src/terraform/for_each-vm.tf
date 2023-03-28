resource "yandex_compute_instance" "web" {
  for_each = toset([ "0", "1" ])
  name = "${var.vm_web_for_each[each.key].vm_name}-${each.key}"
  platform_id   = var.vm_db_instance.platform_id
  resources {
    cores         = var.vm_web_for_each[each.key].cpu
    memory        = var.vm_web_for_each[each.key].ram
    core_fraction = var.vm_web_for_each[each.key].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size = var.vm_web_for_each[each.key].disk
    }
  }
  scheduling_policy {
    preemptible = var.vm_web_instance.scheduling_policy.preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat = var.vm_web_instance.network_interface.nat
  }

  metadata = {
    serial-port-enable = var.vm_metadata.serial-port-enable
    ssh-keys           = local.ssh-keys
  }

  depends_on = [yandex_compute_instance.db]
}
