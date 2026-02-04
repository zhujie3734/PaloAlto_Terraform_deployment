variable "panos_mgmt_ip" { type = string }
variable "panos_username" { type = string }
variable "panos_password" {
  type      = string
  sensitive = true
}

variable "target" {
  type = object({
    vsys = optional(object({
      name = string}), null)

    device_group = optional(object({ name = string}), null)
    template = optional(object({ name = string}), null)
    template_stack = optional(object({ name = string}), null)
    shared = optional(bool, null)
 })
}


variable "palo" {
  type = object({
    network = object({
      virtual_router = optional(string, "vr1")

      interfaces = map(object({
        name = string
        mode = optional(string, "static") # static|dhcp
        ip   = optional(string)           # CIDR when static
      }))

      zones = map(object({
        name = string
        bind = list(string) # bind interface ROLE keys, e.g. ["trust","untrust"]
      }))
    })

    vpn = object({
      ipsec = object({
        tunnels = list(object({
          name    = string
          peer_ip = string # AWS tunnel outside (public) IP
          psk     = string
          # TGW BGP inside tunnel IP（AWS 提供 /30 或 /31，写成 CIDR）
          local_tunnel_ip = string # e.g. "169.254.10.2/30"
          peer_tunnel_ip  = string # e.g. "169.254.10.1/30"

          # 可选覆盖项（不填走默认）
          ike_profile   = optional(string)
          ipsec_profile = optional(string)
          dpd_interval  = optional(number)
        }))
      })

      bgp = object({
        enabled   = bool
        local_asn = number
        peer_asn  = number

        # 可选：你要向 AWS 宣告的网段（例如 vSphere 内网）
        advertise_cidrs = list(string) # e.g. ["10.10.0.0/16"]
      })
    })

    policies = optional(object({
      security_rules = list(object({
        name   = string
        from   = string
        to     = string
        src    = list(string) # CIDR or address-object names
        dst    = list(string)
        app    = list(string) # ["any"] for MVP
        svc    = list(string) # ["application-default"] or ["any"]
        action = string       # "allow"|"deny"
        log    = optional(bool, true)
      }))
    }), null)
  })
}

variable "features" {
  type    = any
  default = {}
}
