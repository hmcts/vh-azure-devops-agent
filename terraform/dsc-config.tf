
resource "azurerm_automation_dsc_configuration" "vh_infra_core_ado" {
  name                    = "adoagent"
  resource_group_name     = azurerm_resource_group.vh_infra_core_ado.name
  automation_account_name = azurerm_automation_account.vh_infra_core_ado.name
  location                = azurerm_resource_group.vh_infra_core_ado.location
  content_embedded        = "configuration adoagent {}"
}

# resource "azurerm_automation_dsc_nodeconfiguration" "timezone" {
#   name                    = "adoagent.localhost"
#   resource_group_name     = "${azurerm_resource_group.aadscrg.name}"
#   automation_account_name = "${azurerm_automation_account.aa.name}"
#   depends_on              = ["azurerm_automation_dsc_configuration.vh_infra_core_ado"]
#   content_embedded        = "${file("./localhost.mof")}"
# }