variable "palo" {
description = "High-level intent object for Palo Alto stack"
type = object({

  network = object({
    virtual_router = string
    interfaces = map(object({
      name = string
      mode = optional(string, "static") # static | dhcp
      ip = optional(string) # CIDR when static
      }))


    zones = map(object({
      name = string
      bind = list(string) # list of interface ROLE keys (e.g. ["trust","untrust"])
      }))
  })


  vpn = object({

    ipsec = object({
      tunnels = list(object({
        name = string
        peer_ip = string # AWS tunnel outside IP
        psk = string


  # Route-based tunnel IPs
        local_tunnel_ip = string # e.g. 169.254.10.2/30
        peer_tunnel_ip = string # e.g. 169.254.10.1/30


  # Optional crypto overrides
        ike_profile = optional(string)
        ipsec_profile = optional(string)
        dpd_interval = optional(number)
      }))
    })


# ---- BGP over IPSec ----
  bgp = object({
    enabled = bool
    local_asn = number
    peer_asn = number
    advertise_cidrs = list(string) # what Palo advertises to TGW
    })
  })


# ========= Security Policy =========
  policies = optional(object({
    security_rules = list(object({
      name = string
      from = string
      to = string
      src = list(string)
      dst = list(string)
      app = list(string)
      svc = list(string)
      action = string # allow | deny
      log = optional(bool, true)
    }))
  }), null)
  })
}

variable "features" {
  type = object({
    interfaces = optional(bool, true)
    zones      = optional(bool, false)
    ipsec      = optional(bool, false)
    bgp        = optional(bool, false)
    policies   = optional(bool, false)
  })
  default = {}
}

variable "target" {
  type = any
}
