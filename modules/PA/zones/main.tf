resource "panos_zone" "this" {
  for_each = var.zones

  name = each.value.name
  mode = "layer3"

  # 注意：pan.dev 教程里 zone 资源就是 interfaces = [...]
  interfaces = each.value.bind_resolved

  enable_user_id = false

  lifecycle {
    create_before_destroy = true
  }
}