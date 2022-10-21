output "tf_vm_names" {
  value = [
    for vm in azurerm_windows_virtual_machine.vh_ado_agent : vm.name
  ]
}