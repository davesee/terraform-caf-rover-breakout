module "dynamic_keyvault_secrets" {
  source = "../../../modules/modules/security/dynamic_keyvault_secrets"
  # source  = "aztfmod/caf/azurerm//modules/security/dynamic_keyvault_secrets"
  # version = "~>5.2.0"

  for_each = try(var.dynamic_keyvault_secrets, {})

  settings = each.value
  keyvault = module.launchpad.keyvaults[each.key]
  objects  = module.launchpad
}
