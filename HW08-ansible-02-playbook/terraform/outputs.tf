output "vm_external_ip_address_clickhouse" {
  value = yandex_compute_instance.platform.network_interface[0].nat_ip_address
  description = "netology-clickhouse external ip"
}
