variable "vcenter_server" {
  type        = string
  description = "The hostname of the vCenter server to use for building"
}

variable "vcenter_user" {
  type        = string
  description = "The username to use when connecting to the vCenter"
}

variable "vcenter_password" {
  type        = string
  sensitive   = true
  description = "The password for the vCenter user"
}

variable "vcenter_datacenter" {
  type        = string
  description = "The name of the datacenter within vCenter to build in"
}

variable "vcenter_cluster" {
  type        = string
  description = "The name of the cluster to build in"
}

variable "vcenter_datastore" {
  type        = string
  description = "The name of the datastore to build in"
}

variable "vm_folder" {
  type        = string
  description = "The folder of the virtual machines to build on"
}

variable "vm_name" {
  type        = string
  description = "The name of the VM when building"
}

variable "vm_template" {
  type        = string
  description = "The name of the VM template"
}

variable "vcpu_nums" {
  type        = number
  description = "The total number of vcpu for the new template VM"
}

#variable "vcpu_per_core" {
#  type        = number
#  description = "The number of cores for the new template VM"
#}


variable "memsize" {
  type        = number
  description = "The memory size for the template VM in MB"
}


variable "network_interfaces" {
  type = list(object({
    network_name      = string
    network_adapter   = option(string, vmxnet3)
  }))
}


#variable "cdrom_type" {
#  type = string
#}

#variable "cd_files" {
#  type        = list(string)
#  description = "path to load config files"
#}

