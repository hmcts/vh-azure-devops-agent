
resource "azurerm_automation_dsc_configuration" "vh_infra_core_ado" {
  name                    = "adoagent"
  resource_group_name     = azurerm_resource_group.vh_infra_core_ado.name
  automation_account_name = azurerm_automation_account.vh_infra_core_ado.name
  location                = azurerm_resource_group.vh_infra_core_ado.location
  content_embedded        = "configuration adoagent {}"

  tags = local.common_tags
}

resource "azurerm_automation_dsc_nodeconfiguration" "adoagent" {
  name                    = "adoagent.localhost"
  resource_group_name     = azurerm_resource_group.vh_infra_core_ado.name
  automation_account_name = azurerm_automation_account.vh_infra_core_ado.name
  depends_on              = ["azurerm_automation_dsc_configuration.vh_infra_core_ado"]
  content_embedded        = file("../dsc/mof/localhost.mof")
}

