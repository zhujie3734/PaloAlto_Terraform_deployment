 terraform {
     required_providers {
        panos = {
             source = "PaloAltoNetworks/panos"
           version = "2.0.8"
         }
    }
  }


module "interfaces" {
    count = try(var.features.interfaces, true) ? 1 : 0
    source = "../interfaces"
    interfaces = var.palo.network.interfaces
    vr_name = var.palo.network.virtual_router
    location = local.location
}


module "zones" {
    count = try(var.features.zones, true) ? 1 : 0
    source = "../zones"
    zones = local.zones_final
    location = local.location
} 


#module "ipsec" {
#    count = try(var.features.ipsec, true) ? 1 : 0
#    source = "../ipsec"
#    vr_name = var.palo.network.virtual_router
#    untrust_zone = var.palo.network.zones.untrust.name
#    tunnels = local.tunnels
#    location = local.location
#}


#module "bgp" {
#    count = try(var.features.bgp, true) ? 1 : 0
#    source = "../bgp"
#    enabled = var.palo.vpn.bgp.enabled
#    vr_name = var.palo.network.virtual_router
#    vr_interfaces = var.palo.network.interfaces
#    local_asn = var.palo.vpn.bgp.local_asn
#    peer_asn = var.palo.vpn.bgp.peer_asn
#    tunnels = local.tunnels
#    advertise_cidrs = var.palo.vpn.bgp.advertise_cidrs
#    location = local.location
#}


module "policies" {
    count = try(var.features.policies, true) ? 1 : 0
    source = "../policies"
    security_rules = try(var.palo.policies.security_rules, [])
}
