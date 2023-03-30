output "vpc_id" {
  value = yandex_vpc_network.new_vpc.id
  description = "vpc id"
}

output "subnet_id" {
  value = [ for subnet in yandex_vpc_subnet.new_subnet : subnet.id ]
  description = "subnets id"
}
