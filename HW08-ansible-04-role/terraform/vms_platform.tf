variable "vm_web_family" {
  type        = string
  default     = "centos-7"
  description = "OS family & release"
}

variable "list_vm_for_lesson83" {
  type      = list(object({
    vm_name=string,
    cpu=number,
    ram=number,
    disk=number,
    core_fraction = number
  }))

  default = [
    {
      vm_name = "clickhouse",
      cpu = 2,
      ram = 4,
      disk = 20,
      core_fraction = 20
    },
    {
      vm_name = "lighthouse",
      cpu = 2,
      ram = 2,
      disk = 20,
      core_fraction = 5
    },
    {
      vm_name = "vector",
      cpu = 2,
      ram = 2,
      disk = 20,
      core_fraction = 5
    }
  ]
}

variable "vm_common_arg" {
  type        = object({
    platform_id       = string,
    scheduling_policy = map(bool),
    network_interface = map(bool)
  })
  default     = {
    platform_id = "standard-v1",
    scheduling_policy = { preemptible = true },
    network_interface = { nat = true }
  }
  description = "resource instance variables"
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