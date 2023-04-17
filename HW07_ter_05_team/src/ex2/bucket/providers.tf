terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.89.0"
    }
    external = {
      version = "2.3.1"
    }
    local = {
      version = "2.4.0"
    }
    null = {
      version = "3.2.1"
    }
  }

#   backend "s3" {
#     endpoint = "storage.yandexcloud.net"
#     bucket = "tfstate-develop-aps"
#     region = "ru-central1"
#     key = "terraform.tfstate"
#     skip_region_validation = true
#     skip_credentials_validation = true
#     dynamodb_endpoint = "https://docapi.serverless.yandexcloud.net/ru-central1/b1g8dbhansmnljtkt5sb/etnmc1fs0odftcsf9mb1"
#     dynamodb_table = "tflock-develop"
#   }
  required_version = ">=0.13"
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone
}
