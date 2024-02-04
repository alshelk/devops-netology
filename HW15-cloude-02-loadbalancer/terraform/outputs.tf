output "route_table" {
    value = [ {"static_route" = yandex_vpc_route_table.nat-instance-route.static_route, "id" = yandex_vpc_route_table.nat-instance-route.id} ]
}


output "instances" {
     value = [{ "ip" = yandex_compute_instance.nat_instance.network_interface[0].ip_address, "name" = yandex_compute_instance.nat_instance.name },
              { "ext_ip" =  yandex_compute_instance.test_vm_public.network_interface[0].nat_ip_address, "ip" = yandex_compute_instance.test_vm_public.network_interface[0].ip_address, "name" = yandex_compute_instance.test_vm_public.name },
              { "ext_ip" =  yandex_compute_instance.test_vm_private.network_interface[0].nat_ip_address, "ip" = yandex_compute_instance.test_vm_private.network_interface[0].ip_address, "name" = yandex_compute_instance.test_vm_private.name }]
}

output "subnet" {
    value = [ {"public_subnet" = yandex_vpc_subnet.public.name, "route_table" = yandex_vpc_subnet.public.route_table_id },
              {"private_subnet" = yandex_vpc_subnet.private.name, "route_table" = yandex_vpc_subnet.private.route_table_id } ]
}

output "vpc" {
    value = yandex_vpc_network.my-vpc.name
}

output "mystore" {
    value = yandex_storage_object.my_store.key

}

output "mybacket" {
    value = yandex_storage_bucket.bucket.bucket_domain_name
}

output "load_balancer" {
    value = yandex_lb_network_load_balancer.lb-1.listener
}

output "application_load_balancer" {
    value = yandex_alb_load_balancer.alb-1.listener
}