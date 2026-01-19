variable "vcenter_server" { type = string }
variable "vcenter_user" { type = string }
variable "vcenter_password" {
  type      = string
  sensitive = true
}

variable "vcenter_datacenter" { type = string }
variable "vcenter_cluster" { type = string }
variable "vcenter_datastore" { type = string }
variable "vm_folder" { type = string }

variable "vm_template" { type = string }
variable "vm_name" { type = string }

variable "networks" {
  description = "Portgroup names in NIC order"
  type        = list(string)
}

variable "sku" {
  description = "small | medium | large"
  type        = string
  default     = "small"
}

variable "bootstrap_build_token" {
  type    = string
  default = ""
}

variable "datastore_iso_path" {
  description = "Path on datastore for ISO, e.g. ISO/bootstrap.iso"
  type        = string
  default     = "ISO/bootstrap.iso"
}

variable "delete_existing_iso" {
  description = "Delete existing ISO on datastore before upload to avoid vCenter 500 on overwrite"
  type        = bool
  default     = true
}
