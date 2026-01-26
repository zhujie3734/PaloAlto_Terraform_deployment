locals {
  default_ike_profile   = "ike-default"
  default_ipsec_profile = "ipsec-default"
  default_dpd_interval  = 10

  iface_name_by_role = { for role, v in var.palo.network.interfaces : role => v.name }

  tunnels = [
    for idx, t in var.palo.vpn.ipsec.tunnels : merge(t, {
      tunnel_if     = "tunnel.${idx + 1}"
      ike_profile   = coalesce(try(t.ike_profile, null), local.default_ike_profile)
      ipsec_profile = coalesce(try(t.ipsec_profile, null), local.default_ipsec_profile)
      dpd_interval  = coalesce(try(t.dpd_interval, null), local.default_dpd_interval)
    })
  ]

  tunnel_ifs = [for t in local.tunnels : t.tunnel_if]

  zones_resolved = {
    for k, z in var.palo.network.zones :
    k => merge(z, {
      bind_resolved = [for r in z.bind : lookup(local.iface_name_by_role, r, r)]
    })
  }

  zones_final = merge(
    local.zones_resolved,
    contains(keys(local.zones_resolved), "vpn")
      ? {
          vpn = merge(local.zones_resolved.vpn, {
            bind_resolved = distinct(concat(local.zones_resolved.vpn.bind_resolved, local.tunnel_ifs))
          })
        }
      : {}
  )
}