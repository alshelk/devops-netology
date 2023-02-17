output "internal_ip_address_manager-01" {
  value = "${yandex_compute_instance.manager[0].network_interface.0.ip_address}"
}

output "external_ip_address_manager-01" {
  value = "${yandex_compute_instance.manager[0].network_interface.0.nat_ip_address}"
}

output "internal_ip_address_manager-02" {
  value = "${yandex_compute_instance.manager[1].network_interface.0.ip_address}"
}

output "external_ip_address_manager-02" {
  value = "${yandex_compute_instance.manager[1].network_interface.0.nat_ip_address}"
}

output "internal_ip_address_manager-03" {
  value = "${yandex_compute_instance.manager[2].network_interface.0.ip_address}"
}

output "external_ip_address_manager-03" {
  value = "${yandex_compute_instance.manager[2].network_interface.0.nat_ip_address}"
}

output "internal_ip_address_worker-01" {
  value = "${yandex_compute_instance.worker[0].network_interface.0.ip_address}"
}

output "external_ip_address_worker-01" {
  value = "${yandex_compute_instance.worker[0].network_interface.0.nat_ip_address}"
}

output "internal_ip_address_worker-02" {
  value = "${yandex_compute_instance.worker[1].network_interface.0.ip_address}"
}

output "external_ip_address_worker-02" {
  value = "${yandex_compute_instance.worker[1].network_interface.0.nat_ip_address}"
}

output "internal_ip_address_worker-03" {
  value = "${yandex_compute_instance.worker[2].network_interface.0.ip_address}"
}

output "external_ip_address_worker-03" {
  value = "${yandex_compute_instance.worker[2].network_interface.0.nat_ip_address}"
}
