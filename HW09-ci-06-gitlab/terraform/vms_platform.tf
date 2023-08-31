#variable "vm_web_family" {
#  type        = string
#  default     = "container-optimized-image"
#  description = "OS family & release"
#}
#
#variable "vm_web_family2" {
#  type        = string
#  default     = "centos-7"
#  description = "OS family & release"
#}
#
#variable "vm_less9" {
#  type      = list(object({
#    vm_name=string,
#    cpu=number,
#    ram=number,
#    disk=number,
#    core_fraction = number,
#    docker-container = string
#  }))
#  default = [
#    {
#      vm_name = "teamcity-server",
#      cpu = 4,
#      ram = 4,
#      disk = 30,
#      core_fraction = 100
#      docker-container = "declaration.yml"
#    },
#    {
#      vm_name = "teamcity-agent",
#      cpu = 2,
#      ram = 4,
#      disk = 30,
#      core_fraction = 100
#      docker-container = "declaration_agent.yml"
#    }
#  ]
#}
#
#variable "nexus" {
#  type      = object({
#    vm_name=string,
#    cpu=number,
#    ram=number,
#    disk=number,
#    core_fraction = number,
#  })
#  default = {
#    vm_name = "nexus",
#    cpu = 2,
#    ram = 2,
#    disk = 20,
#    core_fraction = 20
#  }
#}
#
#variable "vm_common_arg" {
#  type        = object({
#    platform_id       = string,
#    scheduling_policy = map(bool),
#    network_interface = map(bool)
#  })
#  default     = {
#    platform_id = "standard-v3",
#    scheduling_policy = { preemptible = true },
#    network_interface = { nat = true }
#  }
#  description = "resource instance variables"
#}
#
#variable "vm_metadata" {
#  type      = object({
#    serial-port-enable = number
#    ssh-user          = string
#  })
#  default   = {
#    serial-port-enable = 1
#    ssh-user           = "yc-user"
#  }
#}