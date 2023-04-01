output "vault_example" {
 value = "${data.vault_generic_secret.vault_example.data}"
 sensitive = true
}

output "vault_example2" {
 value = "${resource.vault_generic_secret.example2.data}"
 sensitive = true
}

