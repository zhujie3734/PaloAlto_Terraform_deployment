
resource "panos_security_policy_rules" "this" {
count = length(var.security_rules) > 0 ? 1 : 0


# location 在 2.x 是必填（device/vsys/device_group 等），这里给 firewall/vsys 的最常见形式
location = {
vsys = "vsys1"
}


rule = [
for r in var.security_rules : {
name = r.name
from = [r.from]
to = [r.to]
source = r.src
destination = r.dst
application = r.app
service = r.svc
action = r.action
log_end = try(r.log, true)
}
]
}