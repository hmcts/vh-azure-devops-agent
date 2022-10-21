
resource "azurerm_automation_account" "vh_infra_core_ado" {
  name                = "vh-infra-core-ado"
  location            = azurerm_resource_group.vh_infra_core_ado.location
  resource_group_name = azurerm_resource_group.vh_infra_core_ado.name
  sku_name            = "Basic"

  tags = local.common_tags
}

resource "azurerm_automation_module" "cChoco" {
  name                    = "cChoco"
  resource_group_name     = azurerm_resource_group.vh_infra_core_ado.name
  automation_account_name = azurerm_automation_account.vh_infra_core_ado.name

  module_link {
    uri = "https://www.powershellgallery.com/api/v2/package/cChoco/2.5.0.0"
  }
}