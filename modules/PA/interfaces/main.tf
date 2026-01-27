locals {
# interfaces map(role=>{name,mode,ip}) 变成 map(ifname=>obj)
by_ifname = {
for role, v in var.interfaces : v.name => v
}
}


resource "panos_ethernet_interface" "this" {
for_each = local.by_ifname


vsys = "vsys1"
name = each.key
mode = "layer3"


# 静态 or DHCP
enable_dhcp = (try(each.value.mode, "static") == "dhcp")


# static_ips 是 list(string)
static_ips = (try(each.value.mode, "static") == "static" && try(each.value.ip, null) != null) ? [each.value.ip]: []

lifecycle {
create_before_destroy = true
}
}