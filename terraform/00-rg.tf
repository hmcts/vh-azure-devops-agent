resource "azurerm_resource_group" "vh-devops-agent-rg" {
  name     = var.rg_name.ENV
  location = var.location
}