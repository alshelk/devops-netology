#создаем облачную сеть
module "vpc_dev" {
  source        = "../modules/vpc_ex4"
  vpc_name      = "netology"
  subnets       = [
    { zone = "ru-central1-a", cidr = ["10.0.1.0/24"] },
  ]
}

#создаем кластер MySQL
module "cl_mysql" {
  source        = "../modules/create_mysql_cluster"

  cluster_name  = "example"
  network_id    = module.vpc_dev.vpc_id
  subnet_id     = module.vpc_dev.subnet_id[0]
  default_zone  = "ru-central1-a"
  HA            = true

  depends_on    = [module.vpc_dev]
}

# создаем базу данных и пользователя


module "create_db" {
  source        = "../modules/create_db_user"

  cluster_id    = module.cl_mysql.cluster_id
  db_name       = "test"
  user_name     = "app"
  pass          = random_password.password.result
  depends_on    = [module.cl_mysql]

}


resource "random_password" "password" {
  length = 8
  special = true
}


