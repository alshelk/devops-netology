#создаем облачную сеть

/*
# звдвние 2
module "vpc_dev" {
  source = "../modules/vpc"
  vpc_name     = var.vpc_name
  default_cidr = var.default_cidr
  default_zone = var.default_zone
}
*/

/*
#Задание 1
resource "yandex_vpc_network" "develop" {
  name = "develop"
}

#создаем подсеть
resource "yandex_vpc_subnet" "develop" {
  name           = "develop-ru-central1-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}
*/

#Задание 4
module "vpc_prod" {
  source       = "../modules/vpc"
  vpc_name     = "production"
  subnets = [
    { zone = "ru-central1-a", cidr = ["10.0.1.0/24"] },
    { zone = "ru-central1-b", cidr = ["10.0.2.0/24"] },
    { zone = "ru-central1-c", cidr = ["10.0.3.0/24"] },
  ]
}

module "vpc_dev" {
  source       = "../modules/vpc"
  vpc_name     = "develop"
  subnets = [
    { zone = "ru-central1-a", cidr = ["10.0.1.0/24"] },
  ]
}

module "test-vm" {
  source          = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name        = var.vpc_name
  network_id      = module.vpc_dev.vpc_id
  #network_id      = yandex_vpc_network.develop.id
  subnet_zones    = [var.default_zone]
  subnet_ids      = [ module.vpc_dev.subnet_id ]
  #subnet_ids      = [ yandex_vpc_subnet.develop.id ]
  instance_name   = "web"
# instance_count  = 2
  image_family    = "ubuntu-2004-lts"
  public_ip       = true

  metadata = {
      user-data          = data.template_file.cloudinit.rendered
      serial-port-enable = 1
  }

}

#Пример передачи cloud-config в ВМ
data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")
  vars = {
    username           = var.username
    ssh_public_key     = file(var.public_key)
  }
}
