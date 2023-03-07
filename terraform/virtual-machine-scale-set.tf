resource "tls_private_key" "vmss" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_linux_virtual_machine_scale_set" "vh_ado_agent_vmss" {
  name                = var.vmss_name
  location            = azurerm_resource_group.vh_infra_core_ado.location
  resource_group_name = azurerm_resource_group.vh_infra_core_ado.name

  sku       = "Standard_D4s_v4"
  instances = 1

  admin_username = var.vm_username

  source_image_id = "${azurerm_shared_image.ubuntu2204_devops.id}/versions/07032023.0.0"

  admin_ssh_key {
    username   = var.vm_username
    public_key = tls_private_key.vmss.public_key_openssh
  }

  os_disk {
    storage_account_type = "Premium_LRS"
    caching              = "ReadWrite"
  }

  automatic_os_upgrade_policy {
    enable_automatic_os_upgrade = true
    disable_automatic_rollback  = true
  }

  network_interface {
    name    = "${var.vmss_name}-nic"
    primary = true

    ip_configuration {
      name      = "IpConfig"
      primary   = true
      subnet_id = azurerm_subnet.vh_infra_core_ado_snet.id
    }
  }

  tags = local.common_tags
}