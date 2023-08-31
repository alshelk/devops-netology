terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=0.13"
}

resource "yandex_vpc_network" "new_vpc" {
  name = var.vpc_name
}

#создаем подсеть
resource "yandex_vpc_subnet" "new_subnet" {
  count          = length(var.subnets)
  name           = "${var.vpc_name}-${var.subnets[count.index].zone}"
  zone           = var.subnets[count.index].zone
  network_id     = yandex_vpc_network.new_vpc.id
  v4_cidr_blocks = var.subnets[count.index].cidr
}