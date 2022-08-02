locals {
  vms = {
    for item in range(3) :
    "vh-ado-agent-0${item}" => {
      name = "vh-ado-agent-0${item}"
    }
  }
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
output "nics" {
  value = azurerm_network_interface.vh_ado_agent_nic
}

resource "azurerm_linux_virtual_machine" "vh_ado_agent" {
  for_each = local.vms

  name                  = each.value.name
  location              = azurerm_resource_group.vh_infra_core_ado.location
  resource_group_name   = azurerm_resource_group.vh_infra_core_ado.name
  #network_interface_ids = [lookup(azurerm_network_interface.vh_ado_agent_nic, "${each.value.name}-nic").id]
  size                  = "Standard_D4s_v3"

  disable_password_authentication = false #tfsec:ignore:azure-compute-disable-password-authentication
  admin_username                  = var.vm_username
  admin_password                  = random_password.password.result

  os_disk {
    name                 = "${each.value.name}-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 128
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = local.common_tags

  depends_on = [
    azurerm_network_interface.vh_ado_agent_nic
  ]
}


resource "azurerm_virtual_machine_extension" "AzureDevOpsAgent" {
  for_each = local.vms

  name                 = "AzureDevOpsAgent"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"
  virtual_machine_id   = lookup(azurerm_linux_virtual_machine.vh_ado_agent, each.value.name).id

  protected_settings = <<PROTECTED_SETTINGS
      {
          "script": "${filebase64("set_up.sh")}"
      }
  PROTECTED_SETTINGS

  tags = local.common_tags
  depends_on = [
    azurerm_linux_virtual_machine.vh_ado_agent
  ]
}
