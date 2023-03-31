variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
/*
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}
*/

variable "cluster_name" {
  type        = string
  default     = "mysql_cluster"
  description = "Mysql cluster name"
}

variable "cluster_env" {
  type        = string
  default     = "PRESTABLE"
  description = "environment, PRESTABLE or PRODUCTION"
}

variable "network_id" {
  type        = string
  description = "Enter network id"
}

variable "subnet_id" {
  type        = string
  description = "Enter subnet id"
}

variable "public_ip" {
  type        = bool
  default     = "true"
  description = "assign public ip"
}

variable "mysql-v" {
  type        = string
  default     = "8.0"
  description = "MySQL version"
}

variable "del-protect" {
  type        = bool
  default     = false
  description = "deletion protection for cluster"
}

variable "res" {
  type        = object({
    preset_id   = string
    disk_type   = string
    disk_size   = number
  })
  default = {
    preset_id   = "s2.micro"
    disk_type   = "network-ssd"
    disk_size   = 20
  }
  description = "resources for cluster"
}

variable "HA" {
  type        = bool
  default     = true
  description = "high availability cluster"
}

variable "host_name" {
  type        = list(string)
  default     = ["na-1", "na-2", "na-3"]
  description = "Names hosts in cluster"
}


