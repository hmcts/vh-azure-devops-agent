resource "tls_private_key" "vmss" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine_scale_set" "vh_ado_agent_vmss" {
  name                = "vh-ado-agent-vmss"
  location            = azurerm_resource_group.vh_infra_core_ado.location
  resource_group_name = azurerm_resource_group.vh_infra_core_ado.name

  sku       = "Standard_D4s_v3"
  instances = 1

  admin_username = "adoagent"

  admin_ssh_key {
    username   = "adoagent"
    public_key = tls_private_key.vmss.public_key_openssh
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "vh-ado-agent-nic"
    primary = true

    ip_configuration {
      name      = "IpConfig"
      primary   = true
      subnet_id = azurerm_subnet.vh_infra_core_ado_snet.id
    }
  }

  tags = local.common_tags
}