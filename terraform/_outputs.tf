output "tf_vm_names" {
  value = [
    for vm in azurerm_windows_virtual_machine.vh_ado_agent : vm.name
  ]
}

output "resource_group_name" {
  value = azurerm_resource_group.vh_infra_core_ado.name
}

output "automationAccountName" {
  value = azurerm_automation_account.vh_infra_core_ado.name
}