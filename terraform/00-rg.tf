resource "azurerm_resource_group" "vh-devops-agent-rg" {
  name     = var.rg_name
  location = var.location
  tags     = local.common_tags
}