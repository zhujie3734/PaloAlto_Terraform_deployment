locals {
  sku_map = {
    small  = { cpu = 2, memoryMB = 8192,  diskGB = 60  }
    medium = { cpu = 4, memoryMB = 16384, diskGB = 80  }
    large  = { cpu = 8, memoryMB = 32768, diskGB = 120 }
  }

  shape = local.sku_map[var.sku]

  nics = [for n in var.networks : {
    network_name    = n
    network_adapter = "vmxnet3"
  }]

  bootstrap_enabled      = try(var.bootstrap.enabled, true)
  build_token            = try(var.bootstrap.build_token, "")
  datastore_iso_path     = try(var.bootstrap.iso_path, "ISO/bootstrap.iso")
  delete_existing_iso    = try(var.bootstrap.delete_existing_iso, true)

  bootstrap_dir = "${path.module}/bootstrap"
  iso_local     = "${path.module}/bootstrap.iso"
}
