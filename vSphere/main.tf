data "vsphere_datacenter" "dc" {
  name = var.vcenter_datacenter
}

data "vsphere_datastore" "ds" {
  name          = var.vcenter_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vcenter_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "mgmt" {
  name          = var.network_mgmt
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vm_template
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "null_resource" "build_bootstrap_iso" {
  provisioner "local-exec" {
    command = <<EOF
      rm -f ${path.module}/bootstrap.iso
      mkisofs -o ${path.module}/bootstrap.iso -iso-level 4 -l -J -R \
        -V "bootstrap" \
        -graft-points .=${path.module}/bootstrap
    EOF
  }
  triggers = {
    always_run = timestamp()
  }
}

resource "vsphere_file" "bootstrap_iso" {
  depends_on       = [null_resource.build_bootstrap_iso]
  datacenter       = var.vcenter_datacenter
  datastore        = var.vcenter_datastore
  source_file      = "${path.module}/bootstrap.iso"
  destination_file = "ISO/bootstrap.iso"

}

resource "vsphere_virtual_machine" "paloalto" {
  name             = var.vm_name
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.ds.id
  folder           = var.vm_folder
  num_cpus         = var.vcpu_nums
  memory           = var.memsize
  guest_id         = data.vsphere_virtual_machine.template.guest_id

  network_interface {
    network_id   = data.vsphere_network.mgmt.id
    adapter_type = "vmxnet3"
  }

  disk {
    label            = "disk0"
    size             = 60
    thin_provisioned = true
    controller_type  = "scsi"

  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }

  cdrom {
    datastore_id = data.vsphere_datastore.ds.id
    path         = vsphere_file.bootstrap_iso.destination_file
  }
  depends_on = [vsphere_file.bootstrap_iso]
}
