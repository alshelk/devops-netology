variable "vm_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "OS family & release"
}

variable "vm_web_instance" {
  type        = object({
    name              = string,
    platform_id       = string,
    scheduling_policy = map(bool),
    network_interface = map(bool)
  })
  default     = {
    name = "netology-develop-platform-web",
    platform_id = "standard-v1",
    scheduling_policy = { preemptible = true },
    network_interface = { nat = true }
  }
  description = "resource instance variables"
}

variable "vm_db_instance" {
  type        = object({
    name              = string,
    platform_id       = string,
    scheduling_policy = map(bool),
    network_interface = map(bool)
  })
  default     = {
    name              = "netology-develop-platform-db",
    platform_id       = "standard-v1",
    scheduling_policy = { preemptible = true },
    network_interface = { nat = false }
  }
  description = "resource instance variables"
}

variable "vm_web_resources" {
  type      = map(number)
  default   = {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }
}

variable "vm_db_resources" {
  type      = map(number)
  default   = {
    cores         = 2
    memory        = 2
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
    ssh-user           = "ubuntu"
  }
}

variable "vm_web_for_each" {
  type      = list(object({
    vm_name=string,
    cpu=number,
    ram=number,
    disk=number,
    core_fraction = number
  }))

  default = [
    {
      vm_name = "netology-test-platform-web",
      cpu = 2,
      ram = 1,
      disk = 20,
      core_fraction = 5
    },
    {
      vm_name = "netology-develop-platform-web",
      cpu = 4,
      ram = 4,
      disk = 50,
      core_fraction = 20
    }
  ]
}

variable "vm-task3" {
  type = object({
    name = string
    platform_id = string,
    cores = number,
    memory = number,
    core_fraction = number,
    preemptible = bool,
    nat = bool,
    name-disk =string,
    type-disk = string,
    size-disk = number,
    count-disk = number,
    auto_delete = bool
  })
  default = {
    name              = "vm-task3"
    platform_id       = "standard-v1",
    cores             = 2,
    memory            = 1,
    core_fraction     = 5,
    preemptible       = true,
    nat               = true,
    name-disk         = "task3-disk",
    type-disk         = "network-hdd",
    size-disk         = 1,
    count-disk        = 3,
    auto_delete       = true
  }
}