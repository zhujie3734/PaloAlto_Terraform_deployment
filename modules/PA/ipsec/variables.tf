variable "untrust_zone" {
type = string
}

variable "vr_name" {
type = string
}

variable "tunnels" {
type = list(object({
name = string
peer_ip = string
psk = string
local_tunnel_ip = string
peer_tunnel_ip = string
tunnel_if = string
ike_profile = string
ipsec_profile = string
dpd_interval = number
}))
}