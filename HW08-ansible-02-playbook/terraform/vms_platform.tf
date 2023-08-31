variable "vm_web_family" {
  type        = string
  default     = "centos-7"
  description = "OS family & release"
}

variable "vm_clickhouse_instance" {
  type        = object({
    name              = string,
    platform_id       = string,
    scheduling_policy = map(bool),
    network_interface = map(bool)
  })
  default     = {
    name = "netology-clickhouse",
    platform_id = "standard-v1",
    scheduling_policy = { preemptible = true },
    network_interface = { nat = true }
  }
  description = "resource instance variables"
}


variable "vm_clickhouse_resources" {
  type      = map(number)
  default   = {
    cores         = 4
    memory        = 4
    core_fraction = 20
  }
}

variable "vm_metadata" {
  type      = object({
    serial-port-enable = number
    ssh-user          = string
  })
  default   = {
    serial-port-enable = 1
    ssh-user           = "centos"
  }
}