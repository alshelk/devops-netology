output "vm_external_ip_address_clickhouse" {
  value = [
    {"host" = yandex_compute_instance.server.name, "ip" = yandex_compute_instance.server.network_interface[0].nat_ip_address},
    {"host" = yandex_compute_instance.agent.name, "ip" = yandex_compute_instance.agent.network_interface[0].nat_ip_address},
    {"host" = yandex_compute_instance.nexus.name, "ip" = yandex_compute_instance.nexus.network_interface[0].nat_ip_address}
  ]
  description = "external ip"
}

