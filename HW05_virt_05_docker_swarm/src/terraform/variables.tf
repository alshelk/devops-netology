# Заменить на ID своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_cloud_id" {
  default = "b1g8dbhansmnljtkt5sb"
}

# Заменить на Folder своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_folder_id" {
  default = "b1gs8f7ibom6nv7b1qnd"
}

# Заменить на ID своего образа
# ID можно узнать с помощью команды yc compute image list
#variable "ubuntu-2004-lts" {
#  default = data.external.get_id_image.result.id
##  default = "fd8a82hkclcfqmdo1sjb"
#}

variable "zone" {
  default = "ru-central1-a"
}

variable "subnet" {
  default = "e9bc69v1o4e97g116dqa"
}



