
resource "azurerm_key_vault_secret" "keyvault_vh_agent_secret" {
  name            = "vh-devops-agent-password"
  value           = random_password.password.result
  content_type    = "password"
  key_vault_id    = azurerm_key_vault.vh_infra_core_ado.id
  expiration_date = "2030-05-31T00:00:00Z" # PASSWORD WILL EXPIRE 31st May 2030 ##
  tags            = local.common_tags
}