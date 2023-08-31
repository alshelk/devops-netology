locals {
  name_web = "netology-${var.vpc_name}-platform-${var.vpc_role[0]}"
  name_db = "netology-${var.vpc_name}-platform-${var.vpc_role[1]}"
}
