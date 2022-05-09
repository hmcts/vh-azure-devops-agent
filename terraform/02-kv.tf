resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
}

resource "azurerm_key_vault" "keyvault_ado_agent" {
  name                        = var.KV_NAME
  location                    = azurerm_resource_group.vh-devops-agent-rg.location
  resource_group_name         = azurerm_resource_group.vh-devops-agent-rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  # soft_delete_retention_days  = 7
  purge_protection_enabled = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "Set", "List"
    ]
  }
}

resource "azurerm_key_vault_secret" "keyvault_vh_agent_secret" {
  name         = "vh-devops-agent-password"
  value        = random_password.password.result
  key_vault_id = azurerm_key_vault.keyvault_ado_agent.id
}