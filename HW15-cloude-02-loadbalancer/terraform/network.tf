resource "yandex_vpc_network" "my-vpc" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "public" {
  name           = var.subnets_name[0]
  zone           = var.default_zone
  network_id     = yandex_vpc_network.my-vpc.id
  v4_cidr_blocks = var.default_cidr[0]
}

resource "yandex_vpc_subnet" "private" {
  name           = var.subnets_name[1]
  zone           = var.default_zone
  network_id     = yandex_vpc_network.my-vpc.id
  v4_cidr_blocks = var.default_cidr[1]
  route_table_id = yandex_vpc_route_table.nat-instance-route.id
}

