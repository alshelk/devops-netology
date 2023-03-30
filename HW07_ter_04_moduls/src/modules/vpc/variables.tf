/*
variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}
*/
variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

variable "subnets" {
  type	      = list(object)
  default     = [
    { zone = "ru-central1-a", cidr = [ "10.0.1.0/24" ] }
  ]
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope &
    https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

