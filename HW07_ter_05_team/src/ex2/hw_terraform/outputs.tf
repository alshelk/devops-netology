
output "vm_external_ip_address_web" {
  value = module.test-vm.external_ip_address
  description = "external ip"
}

output "s3_access_key" {
  value = yandex_iam_service_account_static_access_key.tfstate-static-key.access_key
  description = "s3 access key"
}

output "s3_secret_key" {
  value = yandex_iam_service_account_static_access_key.tfstate-static-key.secret_key
  description = "s3 secret key"
  sensitive = true
}

