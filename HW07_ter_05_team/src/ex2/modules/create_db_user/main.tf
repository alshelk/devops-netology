terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=0.13"
}


resource "yandex_mdb_mysql_database" "test-db" {
  cluster_id = var.cluster_id
  name       = var.db_name
}

resource "yandex_mdb_mysql_user" "new-user" {
  cluster_id = var.cluster_id
  name       = var.user_name
  password   = var.pass
  permission {
    database_name = yandex_mdb_mysql_database.test-db.name
    roles         = ["ALL"]
  }
}


