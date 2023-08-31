
output "all_vm" {
  value = [
    for serv in local.servers_list : { "name" = serv["name"], id = serv["id"], fqdn = serv["fqdn"] }
  ]
}
