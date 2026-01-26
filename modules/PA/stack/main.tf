module "interfaces" {
    source = "../interfaces"
    interfaces = var.palo.network.interfaces
    vr_name = var.palo.network.virtual_router
}


module "zones" {
    source = "../zones"
    zones = local.zones_final
}


module "ipsec" {
    source = "../ipsec"
    vr_name = var.palo.network.virtual_router
    untrust_zone = var.palo.network.zones.untrust.name
    tunnels = local.tunnels
}


module "bgp" {
    source = "../bgp"
    enabled = var.palo.vpn.bgp.enabled
    vr_name = var.palo.network.virtual_router
    local_asn = var.palo.vpn.bgp.local_asn
    peer_asn = var.palo.vpn.bgp.peer_asn
    tunnels = local.tunnels
    advertise_cidrs = var.palo.vpn.bgp.advertise_cidrs
}


module "policies" {
    source = "../policies"
    security_rules = try(var.palo.policies.security_rules, [])
}