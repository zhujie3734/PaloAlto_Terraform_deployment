variable "placement" {
  type = object({
    datacenter = string
    cluster    = string
    datastore  = string
    folder     = string
  })
}

variable "name"     { type = string }
variable "template" { type = string }

variable "networks" {
  type = list(string)
  validation {
    condition     = length(var.networks) >= 1
    error_message = "networks must contain at least one portgroup name."
  }
}

variable "sku" {
  type    = string
  default = "small"
  validation {
    condition     = contains(["small", "medium", "large"], var.sku)
    error_message = "sku must be one of: small, medium, large."
  }
}

variable "bootstrap" {
  type = object({
    enabled             = optional(bool, true)
    build_token         = optional(string, "")
    iso_path            = optional(string, "ISO/bootstrap.iso")
    delete_existing_iso = optional(bool, true)
  })
  default = {}
}

variable "vcenter" {
  type = object({
    server   = string
    user     = string
    password = string
  })
  sensitive = true
}
