module "vsphere_pa" {
  source = "../../modules/platforms/vsphere/PA_deployment"

  placement = {
    datacenter = var.vcenter_datacenter
    cluster    = var.vcenter_cluster
    datastore  = var.vcenter_datastore
    folder     = var.vm_folder
  }

  name     = var.vm_name
  template = var.vm_template

  networks = var.networks
  sku      = var.sku

  bootstrap = {
    enabled             = true
    build_token         = var.bootstrap_build_token
    iso_path            = var.datastore_iso_path
    delete_existing_iso = var.delete_existing_iso
  }

  vcenter = {
    server   = var.vcenter_server
    user     = var.vcenter_user
    password = var.vcenter_password
  }
}

module "palo_stack" {
  source = "../../modules/palo/stack"

  palo = {
    mgmt = {
      ip = var.panos_mgmt_ip
      username = var.panos_username
      password = var.panos_password
    }
  

  network = {
    interfaces = {
      untrust = { name = "ethernet1/1", mode = "static", ip = "xxx.x.x.x"}
      trust = { name = "ethernet1/1", mode = "static", ip = "xxx.x.x.x"}
    }
  

    zones = {
        untrust = { name = "untrust", bind = ["untrust"] }
        trust   = { name = "trust",   bind = ["trust"] }
        vpn     = { name = "vpn",     bind = ["vpn"] } # vpn 的 bind 由 stack 自动补齐 tunnel interfaces
      }
    }

  vpn = {
      ipsec = {
        tunnels = [
          { name="tgw-1", peer_ip=var.tgw_peer1, psk=var.tgw_psk1 },
          { name="tgw-2", peer_ip=var.tgw_peer2, psk=var.tgw_psk2 },
        ]
      }
    }
  }
}
