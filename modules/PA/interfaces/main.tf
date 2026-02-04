terraform {
      required_providers {
          panos = {
              source = "PaloAltoNetworks/panos"
              version = "2.0.8"
          }
      }
}


locals {
  location = {
    vsys = {
      name = "vsys1"
    }
  }

  by_ifname = {
    for role, v in var.interfaces : v.name => v
 }
}


resource "panos_ethernet_interface" "this" {
  for_each = local.by_ifname
  location = local.location

  name = each.key
  layer3 = {}
  ha = { }

  lifecycle {
create_before_destroy = true
  }
}
