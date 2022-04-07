resource "azurerm_resource_group" "vh-devops-agent-rg" {
  name     = var.RG_NAME
  location = var.location
}