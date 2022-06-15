resource "azurerm_resource_group" "vh_infra_core_ado" {
  name     = var.rg_name
  location = var.location
  tags     = local.common_tags
}