resource "tls_private_key" "vmss" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_virtual_machine_scale_set" "vh_ado_agent_vmss" {
  name                = "vh-ado-agent-vmss"
  location            = azurerm_resource_group.vh_infra_core_ado.location
  resource_group_name = azurerm_resource_group.vh_infra_core_ado.name

  automatic_os_upgrade = false
  upgrade_policy_mode  = "Manual"

  sku {
    name     = "Standard_D4s_v3"
    tier     = "Standard"
    capacity = 1
  }

  storage_profile_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  storage_profile_os_disk {
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name_prefix = "vh-ado-agent-vmss"
    admin_username       = "adoagent"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/adoagent/.ssh/authorized_keys"
      key_data = tls_private_key.vmss.public_key_openssh
    }
  }

  network_profile {
    name    = "vh-ado-agent-vmss"
    primary = true

    ip_configuration {
      name      = "IpConfig"
      primary   = true
      subnet_id = azurerm_subnet.vh_infra_core_ado_snet.id
    }
  }

  tags = local.common_tags
}