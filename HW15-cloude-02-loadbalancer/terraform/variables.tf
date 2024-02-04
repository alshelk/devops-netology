###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}
variable "vpc_name" {
  type        = string
  default     = "my-vpc"
  description = "VPC network name"
}
variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "subnets_name" {
  type        = list(string)
  default     = ["public", "private"]
  description = "subnets name"
}
variable "default_cidr" {
  type        = list(list(string))
  default     = [["192.168.10.0/24"],["192.168.20.0/24"]]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "nat_instance_id" {
  type        = string
  default     = "fd80mrhj8fl2oe87o4e1"
  description = "Nat instance id"
}

variable "lamp_ig_id" {
  type        = string
  default     = "fd827b91d99psvq5fjit"
  description = "LAMP instance id"
}

variable "vm_nat_name" {
  type        = string
  default     = "nat-inst"
  description = "Nat instance Name"
}

variable "ssh_user" {
  type        = string
  default     = "ubuntu"
  description = "ssh user for instances"
}

variable "vm_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "OS family & release"
}

variable "test_vm_instance" {
  type        = object({
    name               = string,
    platform_id        = string,
    scheduling_policy  = map(bool),
    network_interface  = map(bool),
    serial_port_enable = number
  })
  default     = {
    name               = "test-vm-public",
    platform_id        = "standard-v1",
    scheduling_policy  = { preemptible = true },
    network_interface  = { nat = true },
    serial_port_enable = 1
  }
  description = "resource instance variables"
}

variable "vm_resources" {
  type      = map(number)
  default   = {
    cores         = 2
    memory        = 2
    disk          = 8
    core_fraction = 20
  }
}

variable "test_vm_instance2" {
  type        = object({
    name               = string,
    platform_id        = string,
    scheduling_policy  = map(bool),
    network_interface  = map(bool),
    serial_port_enable = number
  })
  default     = {
    name               = "test-vm-private",
    platform_id        = "standard-v1",
    scheduling_policy  = { preemptible = true },
    network_interface  = { nat = false },
    serial_port_enable = 1
  }
  description = "resource instance variables"
}
