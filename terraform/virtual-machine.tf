
# Create Virtual Machine
resource "azurerm_network_interface" "vh_ado_agent_01_nic" {
  name                = "${var.vm_name}-nic"
  location            = azurerm_resource_group.vh_infra_core_ado.location
  resource_group_name = azurerm_resource_group.vh_infra_core_ado.name

  ip_configuration {
    name                          = "IpConfig"
    subnet_id                     = azurerm_subnet.vh_infra_core_ado_snet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.vm_private_ip_address
  }

  tags = local.common_tags
}

resource "azurerm_linux_virtual_machine" "vh_ado_agent_01" {
  # The tfsec:ignore comment below ignores the tfsec password check as the password is random 
  # and only generated at runtime and it is needed by the Azure devops agent that is deployed
  name                  = var.vm_name
  location              = azurerm_resource_group.vh_infra_core_ado.location
  resource_group_name   = azurerm_resource_group.vh_infra_core_ado.name
  network_interface_ids = [azurerm_network_interface.vh_ado_agent_01_nic.id]
  size                  = "Standard_D4s_v3"

  disable_password_authentication = false #tfsec:ignore:azure-compute-disable-password-authentication
  admin_username                  = var.vm_username
  admin_password                  = random_password.password.result

  os_disk {
    name                 = var.vm_osdisk_name
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
}


resource "azurerm_virtual_machine_extension" "AzureDevOpsAgent" {
  name                 = "AzureDevOpsAgent"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"
  virtual_machine_id   = azurerm_linux_virtual_machine.vh_ado_agent_01.id

  protected_settings = <<PROTECTED_SETTINGS
      {
          "script": "${filebase64("set_up.sh")}"
      }
  PROTECTED_SETTINGS

  tags = local.common_tags
}
