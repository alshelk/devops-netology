#создаем облачную сеть
module "vpc_dev" {
  source = "../modules/vpc"
  vpc_name     = var.vpc_name
  default_cidr = var.default_cidr
  default_zone = var.default_zone
}

module "test-vm" {
  source          = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name        = var.vpc_name
  network_id      = module.vpc_dev.vpc_id
  subnet_zones    = [var.default_zone]
  subnet_ids      = [ module.vpc_dev.subnet_id ]
  instance_name   = "web"
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

