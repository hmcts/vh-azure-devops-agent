
resource "azurerm_automation_account" "vh_infra_core_ado" {
  name                = "vh-infra-ado-auto"
  location            = azurerm_resource_group.vh_infra_core_ado.location
  resource_group_name = azurerm_resource_group.vh_infra_core_ado.name
  sku_name            = "Basic"
}