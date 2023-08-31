#создаем облачную сеть
module "vpc_prod" {
  source       = "../modules/vpc_ex4"
  vpc_name     = "production"
  subnets = [
    { zone = "ru-central1-a", cidr = ["10.0.1.0/24"] },
    { zone = "ru-central1-b", cidr = ["10.0.2.0/24"] },
    { zone = "ru-central1-c", cidr = ["10.0.3.0/24"] },
  ]
}

module "vpc_dev" {
  source       = "../modules/vpc_ex4"
  vpc_name     = "develop"
  subnets = [
    { zone = "ru-central1-a", cidr = ["10.0.1.0/24"] },
  ]
}

module "test-vm" {
  source          = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name        = var.vpc_name
  network_id      = module.vpc_dev.vpc_id
  subnet_zones    = [var.default_zone]
  subnet_ids      = [ module.vpc_dev.subnet_id[0] ]
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
