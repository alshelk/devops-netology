
output "vm_external_ip_address_web" {
  value = module.test-vm.external_ip_address
  description = "external ip"
}

/*
output "vm_external_ip" {
  value = yandex_compute_instance.test1.network_interface[0].nat_ip_address
}


output "vm_rendered" {
  value = data.template_file.cloudinit.rendered
}

*/