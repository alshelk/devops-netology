variable "vm_web_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "OS family & release"
}

variable "vm_web_instance" {
  type        = object({
    name              = string,
    platform_id       = string,
#    resources         = map(number),
    scheduling_policy = map(bool),
    network_interface = map(bool)
#    metadata          = map(number)
  })
  default     = {
    name = "netology-develop-platform-web",
    platform_id = "standard-v1",
/*   resources = {
      cores         = 2
      memory        = 1
      core_fraction = 5
    },*/
    scheduling_policy = { preemptible = true },
    network_interface = { nat = true }
#    metadata          = { serial-port-enable = 1}
  }
  description = "resource instance variables"
}

/*
variable "vms_ssh_user" {
  type        = string
  default     = "ubuntu"
  description = "Root user for OS"
}
*/

variable "vm_db_instance" {
  type        = object({
    name              = string,
    platform_id       = string,
#    resources         = map(number),
    scheduling_policy = map(bool),
    network_interface = map(bool)
#    metadata          = map(number)
  })
  default     = {
    name              = "netology-develop-platform-db",
    platform_id       = "standard-v1",
/*    resources         = {
      cores             = 2
      memory            = 2
      core_fraction     = 20
    },*/
    scheduling_policy = { preemptible = true },
    network_interface = { nat = true }
#    metadata          = { serial-port-enable = 1}
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