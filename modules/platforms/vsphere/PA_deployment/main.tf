terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.5"
    }
  }
}

data "vsphere_datacenter" "dc" {
  name = var.placement.datacenter
}

data "vsphere_datastore" "ds" {
  name          = var.placement.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.placement.cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "networks" {
  for_each      = { for nic in local.nics : nic.network_name => nic }
  name          = each.key
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "null_resource" "build_bootstrap_iso" {
  count = local.bootstrap_enabled ? 1 : 0

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-lc"]
    #<<EOF instead of -<<EOF to ensure iso format, preventing bootstrap failure
    command = <<EOF
      rm -f "${local.iso_local}"
      mkisofs -o "${local.iso_local}" -iso-level 4 -l -J -R -V "bootstrap" -graft-points .="${local.bootstrap_dir}"
    EOF
  }
}


resource "vsphere_file" "bootstrap_iso" {
  count = local.bootstrap_enabled ? 1 : 0
  datacenter       = var.placement.datacenter
  datastore        = var.placement.datastore
  source_file      = local.iso_local
  destination_file = local.datastore_iso_path
  
  depends_on = [null_resource.build_bootstrap_iso]

}

data "vsphere_virtual_machine" "template" {
  name          = var.template
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "pa" {
  name             = var.name
  folder           = var.placement.folder
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.ds.id

  num_cpus = local.shape.cpu
  memory   = local.shape.memoryMB
  guest_id  = data.vsphere_virtual_machine.template.guest_id

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }

  dynamic "network_interface" {
    for_each = local.nics
    iterator = nic
    content {
      network_id   = data.vsphere_network.networks[nic.value.network_name].id
      adapter_type = nic.value.network_adapter
    }
  }

  disk {
    label            = "disk0"
    size             = local.shape.diskGB
    thin_provisioned = true
    controller_type  = "scsi"
  }

  cdrom {
    datastore_id = data.vsphere_datastore.ds.id
    path         = vsphere_file.bootstrap_iso[0].destination_file
  }

  depends_on = [vsphere_file.bootstrap_iso]
}
