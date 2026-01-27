locals {
tunnels = { for t in var.tunnels : t.name => t }


# 取每条隧道的 peer inside IP（去掉 /30）
peer_inside_ips = {
for k, t in local.tunnels : k => cidrhost(t.peer_tunnel_ip, 0)
}


# router-id 简单做法：取第一条 tunnel 的本地 inside IP（去掉掩码）
router_id = cidrhost(var.tunnels[0].local_tunnel_ip, 0)
}


resource "panos_virtual_router" "this" {
count = var.enabled ? 1 : 0


name = var.vr_name
interfaces = var.vr_interfaces


# ↓↓↓ BGP 这块 nested schema 在 2.x 里是 virtual_router.protocol.bgp（大概率长这样）
# 如果 validate 报字段名不对，你按报错改（通常是结构名/字段名微调）
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
# multi-hop / bfd / timers 你后面再加
}
]
}]


# 发布路由：按你的 schema，直接用 advertise_cidrs
network = [
for c in var.advertise_cidrs : { prefix = c }
]
}
}


lifecycle {
create_before_destroy = true
}
}