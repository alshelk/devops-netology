resource "yandex_vpc_network" "training" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "training" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.training.id
  v4_cidr_blocks = var.default_cidr
}

data "yandex_compute_image" "container-optimized-image" {
  family = var.vm_web_family
}

