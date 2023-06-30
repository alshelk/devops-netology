output "vm_external_ip_address_clickhouse" {
  value = [
    yandex_compute_instance.server.network_interface[0].nat_ip_address,
    yandex_compute_instance.agent.network_interface[0].nat_ip_address
  ]
  description = "external ip"
}

