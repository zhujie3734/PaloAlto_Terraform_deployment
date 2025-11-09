
vcenter_server     = "192.168.1.1"
vcenter_user       = "admin@vsphere.local"
vcenter_password   = "xxxxx"
vcenter_datacenter = "INTDMZ"
vcenter_cluster    = "INTDMZ-CLUSTER"
vcenter_datastore = "LocalStorage-192.168.1.1"
vm_folder         = "LD_Test"
vm_template       = "PA-VM-ESX-10.1.9-template"
vm_name           = "vApp-PA-test"
#os_type                 = "windows2019srvNext_64Guest"
vcpu_nums = 4
#vcpu_per_core           = 4
memsize      = 8192
network_interfaces = [
  {
    network_name = "Mgmt-63"
    adapter_type = "vmxnet3"
  },
  {
    network_name = "DMZ-26"
  },
  {
    network_name = "DMZ-25"
  },
  {
    network_name = "DMZ-22"
  }

]
