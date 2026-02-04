variable "zones" {
type = map(object({
name = string
bind_resolved = list(string)
}))
}

variable "location" {
  type = any
}
