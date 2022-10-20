
# resource "azurerm_automation_dsc_configuration" "vh_infra_core_ado" {
#   name                    = "SelfHostedAgent"
#   resource_group_name     = azurerm_resource_group.vh_infra_core_ado.name
#   automation_account_name = azurerm_automation_account.vh_infra_core_ado.name
#   location                = azurerm_resource_group.vh_infra_core_ado.location
#   content_embedded        = file("./SelfHostedAgent.ps1")

#   tags = local.common_tags
# }

# resource "azurerm_automation_dsc_nodeconfiguration" "adoagent" {
#   name                    = "SelfHostedAgent.localhost"
#   resource_group_name     = azurerm_resource_group.vh_infra_core_ado.name
#   automation_account_name = azurerm_automation_account.vh_infra_core_ado.name
#   content_embedded        = file("./localhost.mof")

#   depends_on = [
#     azurerm_automation_dsc_configuration.vh_infra_core_ado
#   ]
# }