terraform {
    required_providers {
        panos = {
            source = "PaloAltoNetworks/panos"
            version = "2.0.8"
        }
    }
}

provider "panos" {
    hostname = var.panos.mgmt_ip
    username = var.panos.username
    password = var.panos_password
}