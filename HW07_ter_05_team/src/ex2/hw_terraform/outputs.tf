
output "vm_external_ip_address_web" {
  value = module.test-vm.external_ip_address
  description = "external ip"
}

