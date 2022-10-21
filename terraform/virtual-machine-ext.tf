locals {
  winscript             = "powershell Set-ExecutionPolicy Bypass -Scope Process -Force; powershell Enable-PsRemoting -SkipNetworkProfileCheck -Force; powershell exit 0"
}

resource "azurerm_virtual_machine_extension" "ps_remoting" {
  for_each = local.vms

  name                 = "PostDeploymentScript"
  virtual_machine_id   = azurerm_windows_virtual_machine.vh_ado_agent[each.value.name].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  protected_settings = <<PSETTINGS
    {
       "commandToExecute": "${local.winscript}"
    }
PSETTINGS

  tags = local.common_tags

  depends_on = [
    azurerm_windows_virtual_machine.vh_ado_agent
  ]
}

resource "azurerm_virtual_machine_extension" "AADLoginForWindows" {
  for_each = local.vms

  name                       = "AADLoginForWindows"
  virtual_machine_id         = azurerm_windows_virtual_machine.vh_ado_agent[each.value.name].id
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADLoginForWindows"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true

  depends_on = [
    azurerm_windows_virtual_machine.vh_ado_agent,
    azurerm_virtual_machine_extension.ps_remoting
  ]

}

resource "azurerm_role_assignment" "IAM_VMLogin" {
  scope                = azurerm_resource_group.vh_infra_core_ado.id
  role_definition_name = "Virtual Machine Administrator Login"
  principal_id         = "5c77fdba-1174-4bf3-8faa-934133dac70d" #BG for test
}