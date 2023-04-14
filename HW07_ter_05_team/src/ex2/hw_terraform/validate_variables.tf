variable "ip_address" {
  type        = string
  description = "ip-address"
  validation {
    condition     = can(cidrnetmask(var.ip_address))
    error_message = "Must be a valid IPv4 address."
  }
}

variable "ip_addresses" {
  type        = list(string)
  description = "list of ip-idresses"
  validation {
    condition = alltrue([
      for a in var.ip_addresses : can(cidrnetmask(a))
    ])
    error_message = "All elements must be valid IPv4 addresses."
  }
}

variable "small_string" {
  type        = string
  description = "any string"
  validation {
    condition     = lower(var.small_string) == var.small_string
    error_message = "String must not contain uppercase characters"
  }
}


variable "in_the_end_there_can_be_only_one" {
    description="Who is better Connor or Duncan?"
    type = object({
        Dunkan = optional(bool)
        Connor = optional(bool)
    })

    default = {
        Dunkan = true
        Connor = false
    }

    validation {
        error_message = "There can be only one MacLeod"
        condition = <проверка>
    }
}