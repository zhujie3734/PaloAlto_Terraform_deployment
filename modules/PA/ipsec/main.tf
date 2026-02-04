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
}

# 1) tunnel interface + inside IP
resource "panos_tunnel_interface" "this" {
  for_each = local.tunnels

  vsys = "vsys1"
  name = each.value.tunnel_if
  location = var.location
  # tunnel interface inside IP
  static_ips = [each.value.local_tunnel_ip]

  lifecycle {
    create_before_destroy = true
  }
}

# 2) IKE gateway（到 AWS 的 public peer）
resource "panos_ike_gateway" "this" {
  for_each = local.tunnels

  name = "${each.value.name}-ike"

  # 常见字段：version / peer_ip / interface / local_ip / psk 等
  # 你用 TGW：通常 peer 是 public IP，接口是 untrust 的 ethernet
  # ↓↓↓ 这里的字段名可能需要你按 2.0.8 validate 报错微调 ↓↓↓
  version    = "ikev2"
  peer_ip    = each.value.peer_ip
  interface  = "ethernet1/1"    # 你可以后面改成从 stack 传 untrust_ifname 进来
  # local_ip = "203.0.113.10"   # 如果需要指定本地出接口 IP
  location = var.location
  authentication {
    pre_shared_key = each.value.psk
  }

  enable_nat_traversal = true

  lifecycle {
    create_before_destroy = true
  }
}

# 3) IPSec tunnel（route-based）
resource "panos_ipsec_tunnel" "this" {
  for_each = local.tunnels

  name          = each.value.name
  tunnel_if     = each.value.tunnel_if
  anti_replay   = true
  enable_gre_encapsulation = false

  auto_key {
    ike_gateway = [{
      name = panos_ike_gateway.this[each.key].name
    }]

    ipsec_crypto_profile = each.value.ipsec_profile
  }

  depends_on = [panos_tunnel_interface.this]
}
