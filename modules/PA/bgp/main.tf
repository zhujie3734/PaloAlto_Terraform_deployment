terraform {
     required_providers {
         panos = {
             source = "PaloAltoNetworks/panos"
             version = "2.0.8"
         }
     }
 }

locals {
  tunnels = { for t in var.tunnels : t.name => t }

  peer_inside_ips = {
    for k, t in local.tunnels : k => cidrhost(t.peer_tunnel_ip, 0)
}

  router_id = cidrhost(var.tunnels[0].local_tunnel_ip, 0)
}


resource "panos_virtual_router" "this" {
  count = var.enabled ? 1 : 0
  name = var.vr_name
  interfaces = var.vr_interfaces
  location = var.location

  protocol {
    bgp {
      enable = true
      router_id = local.router_id
      local_as = var.local_asn

      peer_group = [{
        name = "tgw"
        peer = [
          for k, t in local.tunnels : {
            name = "${t.name}-peer"
            peer_as = var.peer_asn
            peer_addr = local.peer_inside_ips[k]
          }
        ] 
      }]

      network = [
        for c in var.advertise_cidrs : { prefix = c }
      ] 
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
