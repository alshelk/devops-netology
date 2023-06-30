variable "vm_web_family" {
  type        = string
  default     = "centos-7"
  description = "OS family & release"
}

variable "vm_less9" {
  type      = object({
    vm_name=list(string),
    cpu=number,
    ram=number,
    disk=number,
    core_fraction = number
  })
  default = {
      vm_name = ["jenkins-master-01", "jenkins-agent-01"],
      cpu = 2,
      ram = 4,
      disk = 20,
      core_fraction = 20
  }
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