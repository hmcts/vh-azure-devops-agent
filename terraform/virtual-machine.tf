locals {
  vms = {
    for item in range(var.vm_count) :
    "vh-ado-agent-0${item + 1}" => {
      name      = "vh-ado-agent-0${item + 1}"
      os_disk   = "vh-ado-agent-0${item + 1}-OsDisk"
      data_disk = "vh-ado-agent-0${item + 1}-DataDisk"
    }
  }
  publisher             = "microsoftwindowsdesktop"
  offer                 = "windows-11"
  sku                   = "win11-21h2-pro"
  version               = "latest"
  dsc_ConfigurationMode = "ApplyAndAutoCorrect"
  winscript             = "powershell Set-ExecutionPolicy Bypass -Scope Process -Force; Enable-PsRemoting -Force"
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

resource "azurerm_virtual_machine_data_disk_attachment" "example" {
  for_each = local.vms

  managed_disk_id    = azurerm_managed_disk.vh_ado_agent[each.value.data_disk].id
  virtual_machine_id = azurerm_windows_virtual_machine.vh_ado_agent[each.value.name].id
  lun                = "10"
  caching            = "ReadWrite"
}

resource "azurerm_virtual_machine_extension" "ps_remoting" {
  for_each = local.vms

  name                 = "psRemoting-${each.value.name}"
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

resource "azurerm_virtual_machine_extension" "dsc" {
  for_each = local.vms

  name                 = "DevOpsDSC"
  virtual_machine_id   = azurerm_windows_virtual_machine.vh_ado_agent[each.value.name].id
  publisher            = "Microsoft.Powershell"
  type                 = "DSC"
  type_handler_version = "2.83"

  settings = <<SETTINGS_JSON
        {
          "configurationArguments": {
              "RegistrationUrl": "${azurerm_automation_account.vh_infra_core_ado.dsc_server_endpoint}",
              "NodeConfigurationName": "localhost",
              "ConfigurationMode": "${local.dsc_ConfigurationMode}",
              "ConfigurationModeFrequencyMins": 15,
              "RefreshFrequencyMins": 30,
              "RebootNodeIfNeeded": false,
              "ActionAfterReboot": "continueConfiguration",
              "AllowModuleOverwrite": true
          }
        }
    SETTINGS_JSON

  protected_settings = <<PROTECTED_SETTINGS_JSON
    {
      "configurationArguments": {
         "RegistrationKey": {
                  "UserName": "PLACEHOLDER_DONOTUSE",
                  "Password": "${azurerm_automation_account.vh_infra_core_ado.dsc_primary_access_key}"
                }
      }
    }
PROTECTED_SETTINGS_JSON

  tags = local.common_tags

  depends_on = [
    azurerm_windows_virtual_machine.vh_ado_agent,
    azurerm_virtual_machine_extension.ps_remoting
  ]

}
