variable "interfaces" {
type = map(object({
name = string
mode = optional(string, "static")
ip = optional(string)
}))
}


variable "vr_name" {
type = string
}