resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
}

#tfsec:ignore:azure-keyvault-specify-network-acl
resource "azurerm_key_vault" "vh_infra_core_ado" {
  name                        = var.key_vault_name
  location                    = azurerm_resource_group.vh_infra_core_ado.location
  resource_group_name         = azurerm_resource_group.vh_infra_core_ado.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  # KV purge protection ignored due to the use of the KV only to store an Agent password
  # soft_delete_retention_days  = 7
  purge_protection_enabled = false #tfsec:ignore:azure-keyvault-no-purge

  #tfsec:ignore:azure-keyvault-specify-network-acl
  # network_acls {
  #   bypass         = "AzureServices"
  #   default_action = "Allow"
  #}

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "Set", "List", "Delete", "Purge"
    ]
  }
  tags = local.common_tags
}
resource "azurerm_key_vault_access_policy" "temp" {
  key_vault_id = azurerm_key_vault.vh_infra_core_ado.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = "216a0f7e-97b3-4ebc-ad19-9ccdd0f59077"

  key_permissions = [
    "Get",
  ]

  secret_permissions = [
    "Get", "Set", "List", "Delete", "Purge"
  ]
}