terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=0.13"
}

resource "yandex_mdb_mysql_cluster" "cl_mysql" {
  name                = var.cluster_name
  environment         = var.cluster_env
  network_id          = var.network_id
  version             = var.mysql-v
  deletion_protection = var.del-protect

  resources {
    resource_preset_id  = var.res.preset_id
    disk_type_id        = var.res.disk_type
    disk_size           = var.res.disk_size
  }


  dynamic "host" {
    for_each            = var.HA == true ? var.host_name : [var.host_name[0]]
    content {
      name             = host.value
      zone             = var.default_zone
      subnet_id        = var.subnet_id
      assign_public_ip = var.public_ip
    }
  }
}

