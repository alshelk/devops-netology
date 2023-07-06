resource "yandex_kubernetes_cluster" "cluster-mskuber" {
 network_id = yandex_vpc_network.training.id
 master {
   zonal {
     zone      = var.default_zone
     subnet_id = yandex_vpc_subnet.training.id
   }
 }
 service_account_id      = yandex_iam_service_account.sa.id
 node_service_account_id = yandex_iam_service_account.sa.id
   depends_on = [
     yandex_resourcemanager_folder_iam_member.admin-account-iam
#     yandex_resourcemanager_folder_iam_member.images-puller
   ]
}


#resource "yandex_iam_service_account" "<имя сервисного аккаунта>" {
# name        = "<имя сервисного аккаунта>"
# description = "<описание сервисного аккаунта>"
#}
#
#resource "yandex_resourcemanager_folder_iam_member" "editor" {
# # Сервисному аккаунту назначается роль "editor".
# folder_id = "<идентификатор каталога>"
# role      = "editor"
# member    = "serviceAccount:${yandex_iam_service_account.<имя сервисного аккаунта> id}"
#}
#
#resource "yandex_resourcemanager_folder_iam_member" "images-puller" {
# # Сервисному аккаунту назначается роль "container-registry.images.puller".
# folder_id = "<идентификатор каталога>"
# role      = "container-registry.images.puller"
# member    = "serviceAccount:${yandex_iam_service_account.<имя сервисного аккаунта>.id}"
#}

resource "yandex_kubernetes_node_group" "group-hosts" {
  cluster_id = yandex_kubernetes_cluster.cluster-mskuber.id
  name       = "group-kuber"

  instance_template {
    name       = "node-{instance.index}"
    platform_id = "standard-v1"
    container_runtime {
     type = "containerd"
    }
    resources {
      cores         = "2"
      memory        = "2"
      core_fraction = "20"
    }
#    labels {
#      vcpu = "2"
#      ram = "2"
#    }

  }

  scale_policy {
    fixed_scale {
      size = 2
    }
  }
}