data "vault_generic_secret" "vault_example"{
 path = "secret/example"
}

resource "vault_generic_secret" "example2" {
  path = "secret/example2"

  data_json = "${file("./vault.json")}"
}
