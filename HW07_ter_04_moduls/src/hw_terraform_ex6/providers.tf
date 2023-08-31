terraform {
  required_providers {

    vault = {
      source = "hashicorp/vault"
      version = "~> 3.0.0"
    }
  }
}

provider "vault" {
 address = "http://127.0.0.1:8200/"
 skip_tls_verify = true
 token = "education"
}
