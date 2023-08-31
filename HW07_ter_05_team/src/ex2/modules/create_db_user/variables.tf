variable "cluster_id" {
  type        = string
  description = "Enter cluster id"
}

variable "db_name" {
  type        = string
  default     = "test-db"
  description = "Name database"
}

variable "user_name" {
  type        = string
  default     = "root"
  description = "Name user"
}

variable "pass" {
  type        = string
  description = "Enter password for user MySQL"
}
