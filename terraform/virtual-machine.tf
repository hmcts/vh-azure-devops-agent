locals {
  vms = {
    for item in range(var.vm_count) :
    "vh-ado-agent-0${item + 1}" => {
      name      = "vh-ado-agent-0${item + 1}"
      os_disk   = "vh-ado-agent-0${item + 1}-OsDisk"
      data_disk = "vh-ado-agent-0${item + 1}-DataDisk"
    }
  }
  publisher             = "MicrosoftWindowsDesktop"
  offer                 = "windows-10"
  sku                   = "win10-21h2-pro-g2"
  version               = "latest"
  dsc_ConfigurationMode = "ApplyAndAutoCorrect"
  winscript             = "powershell Set-ExecutionPolicy Bypass -Scope Process -Force; powershell Enable-PsRemoting -SkipNetworkProfileCheck -Force; powershell exit 0"
}

# Create Virtual Machine
resource "azurerm_network_interface" "vh_ado_agent_nic" {
  for_each = local.vms

  name                = "${each.value.name}-nic"
  location            = azurerm_resource_group.vh_infra_core_ado.location
  resource_group_name = azurerm_resource_group.vh_infra_core_ado.name

  ip_configuration {
    name                          = "IpConfig"
    subnet_id                     = azurerm_subnet.vh_infra_core_ado_snet.id
    private_ip_address_allocation = "Dynamic"

    public_ip_address_id = var.env == "dev" ? azurerm_public_ip.dev_pip[each.value.name].id : null

  }

  tags = local.common_tags
}

resource "azurerm_windows_virtual_machine" "vh_ado_agent" {
  for_each = local.vms

  name                  = each.value.name
  location              = azurerm_resource_group.vh_infra_core_ado.location
  resource_group_name   = azurerm_resource_group.vh_infra_core_ado.name
  network_interface_ids = [azurerm_network_interface.vh_ado_agent_nic[each.value.name].id]
  size                  = "Standard_D4s_v3"

  admin_username = var.vm_username
  admin_password = random_password.password.result

  os_disk {
    name                 = each.value.os_disk
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 128
  }

  source_image_reference {
    publisher = local.publisher
    offer     = local.offer
    sku       = local.sku
    version   = local.version
  }

  tags = local.common_tags

  depends_on = [
    azurerm_network_interface.vh_ado_agent_nic,
    azurerm_automation_account.vh_infra_core_ado
  ]

}

resource "azurerm_managed_disk" "vh_ado_agent" {
  for_each = local.vms

  name                 = each.value.data_disk
  location             = azurerm_resource_group.vh_infra_core_ado.location
  resource_group_name  = azurerm_resource_group.vh_infra_core_ado.name
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = "64"

  tags = local.common_tags

}

resource "azurerm_virtual_machine_data_disk_attachment" "data_disk_attachment" {
  for_each = local.vms

  managed_disk_id    = azurerm_managed_disk.vh_ado_agent[each.value.name].id
  virtual_machine_id = azurerm_windows_virtual_machine.vh_ado_agent[each.value.name].id
  lun                = "10"
  caching            = "ReadWrite"
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