module "palo_stack" {
source = "../../../modules/palo/stack"

palo = merge(var.palo, {
    mgmt = {
        ip = var.panos_mgmt_ip
        username = var.panos_username
        password = var.panos_password
    }
  })
}

