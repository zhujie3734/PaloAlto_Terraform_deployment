module "palo_stack" {
  source = "../../../modules/PA/stack"

  target   = var.target
  palo     = var.palo
  features = var.features
}

