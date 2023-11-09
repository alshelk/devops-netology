locals {
  ssh-keys  = "${var.vm_metadata.ssh-user}:${file("~/.ssh/id_rsa.pub")}"

  mnode_name = flatten([
    for t in var.k8s_type_install : [
      for i in range(1, var.count_mnode+1) : "master-node-${t}-${i}"
    ]
  ])

  wnode_name =  flatten([
    for t in var.k8s_type_install : [
      for i in range(1, var.count_wnode+1) : "worker-node-${t}-${i}"
    ]
  ])
}

locals {
  servers_list = concat([ for i in yandex_compute_instance.mnode : i], [ for i in yandex_compute_instance.wnode : i])
}

# output "mnode_name" {
#   value = local.mnode_name
# }
#
# output "wnode_name" {
#   value = local.wnode_name
# }