 terraform {
     required_providers {
          panos = {
             source = "PaloAltoNetworks/panos"
              version = "2.0.8"
        }
     }
 }


resource "panos_zone" "this" {
  for_each = var.zones

  name = each.value.name
  mode = "layer3"
  location = var.location
  interfaces = each.value.bind_resolved

  enable_user_id = false

  lifecycle {
    create_before_destroy = true
  }
}
