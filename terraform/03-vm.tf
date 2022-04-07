# Create Virtual Machine

resource "azurerm_public_ip" "vh-agent-pip" {
  name                = var.vm_pip_name
  location            = var.location
  resource_group_name = azurerm_resource_group.vh-devops-agent-rg.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "vh-devops-nic" {
  name                = "${var.vm_name}-nic"
  location            = azurerm_resource_group.vh-devops-agent-rg.location
  resource_group_name = azurerm_resource_group.vh-devops-agent-rg.name

  ip_configuration {
    name                          = "ip"
    subnet_id                     = azurerm_subnet.vh-devops-agent-subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.vm_private_ip_address
    public_ip_address_id          = azurerm_public_ip.vh-agent-pip.id
  }
}

resource "azurerm_virtual_machine" "vh-devops-agent-vm" {
  name                  = var.VM_NAME # "${var.vm_name}-vm"
  location              = azurerm_resource_group.vh-devops-agent-rg.location
  resource_group_name   = azurerm_resource_group.vh-devops-agent-rg.name
  network_interface_ids = [azurerm_network_interface.vh-devops-nic.id]
  vm_size               = "Standard_DS2_v2"

  storage_os_disk {
    name              = var.vm_osdisk_name
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }


  os_profile {
    computer_name  = var.VM_NAME # "${var.vm_name}-vm"
    admin_username = var.vm_username
    admin_password = random_password.password.result
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}


resource "azurerm_virtual_machine_extension" "create-agent" {
  name                 = "create-agent"
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"
  virtual_machine_id   = azurerm_virtual_machine.vh-devops-agent-vm.id

  settings = <<SETTINGS
    {
        "script": "${filebase64("set_up.sh")}"
    }
SETTINGS
}