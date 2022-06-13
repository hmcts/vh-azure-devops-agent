# Create Virtual Machine
resource "azurerm_network_interface" "vh-devops-nic" {
  name                = "${var.vm_name}-nic"
  location            = azurerm_resource_group.vh-devops-agent-rg.location
  resource_group_name = azurerm_resource_group.vh-devops-agent-rg.name

  ip_configuration {
    name                          = "ip"
    subnet_id                     = azurerm_subnet.vh-devops-agent-subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.vm_private_ip_address
  }
}

resource "azurerm_linux_virtual_machine" "vh-devops-agent-vm" {
  # The tfsec:ignore comment below ignores the tfsec password check as the password is random 
  # and only generated at runtime and it is needed by the Azure devops agent that is deployed
  disable_password_authentication = false #tfsec:ignore:azure-compute-disable-password-authentication
  name                            = var.vm_name
  admin_username                  = var.vm_username
  admin_password                  = random_password.password.result
  location                        = azurerm_resource_group.vh-devops-agent-rg.location
  resource_group_name             = azurerm_resource_group.vh-devops-agent-rg.name
  network_interface_ids           = [azurerm_network_interface.vh-devops-nic.id]
  size                            = "Standard_D4s_v3" # "Standard_DS2_v2"

  os_disk {
    name                 = var.vm_osdisk_name
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 128
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

}


resource "azurerm_virtual_machine_extension" "create-agent" {
  name                 = "create-agent"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"
  virtual_machine_id   = azurerm_linux_virtual_machine.vh-devops-agent-vm.id

  protected_settings = <<PROTECTED_SETTINGS
      {
          "script": "${filebase64("set_up.sh")}"
      }
  PROTECTED_SETTINGS

}
