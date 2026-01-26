variable "enabled" {
type = bool
description = "Enable BGP configuration"
}


variable "vr_name" {
type = string
description = "Virtual router name"
}


variable "local_asn" {
type = number
description = "Local ASN on Palo Alto"
}


variable "peer_asn" {
type = number
description = "Peer ASN (AWS TGW VPN ASN)"
}


variable "tunnels" {
description = "Normalized tunnels from stack locals (includes tunnel_if and inside IPs)"
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


variable "advertise_cidrs" {
type = list(string)
description = "CIDRs to advertise to TGW over BGP"
default = []
}