output "vm_external_ip_address_clickhouse" {
  value = [
    for vm in yandex_compute_instance.test : {"host" = vm.name, "ip" = vm.network_interface[0].nat_ip_address}
  ]
  description = "external ip"
}
