variable "vm_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "OS family & release"
}

variable "mnode_instance" {
  type        = object({
    name              = string,
    platform_id       = string,
    scheduling_policy = map(bool),
    network_interface = map(bool)
  })
  default     = {
    name = "master-node",
    platform_id = "standard-v1",
    scheduling_policy = { preemptible = true },
    network_interface = { nat = true }
  }
  description = "resource instance variables"
}

variable "wnode_instance" {
  type        = object({
    name              = string,
    platform_id       = string,
    scheduling_policy = map(bool),
    network_interface = map(bool)
  })
  default     = {
    name              = "work-node",
    platform_id       = "standard-v1",
    scheduling_policy = { preemptible = true },
    network_interface = { nat = false }
  }
  description = "resource instance variables"
}

variable "mnode_resources" {
  type      = map(number)
  default   = {
    cores         = 2
    memory        = 2
    disk          = 50
    core_fraction = 20
  }
}

variable "wnode_resources" {
  type      = map(number)
  default   = {
    cores         = 2
    memory        = 2
    disk          = 50
    core_fraction = 5
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

