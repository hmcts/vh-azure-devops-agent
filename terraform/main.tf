module "ado_agent" {
  source = "git::https://github.com/hmcts/cnp-terraform-module-azure-devops-agent.git?ref=VIH-9741"

  resource_group_name = var.rg_name
  location            = var.location

  vnet_name          = var.vnet_name
  vnet_address_space = var.vnet_ip_address

  subnet_name           = var.subnet_name_vh_agent
  subnet_address_prefix = var.subnet_name_vh_agent_address

  peering_client_id     = var.peering_client_id
  peering_client_secret = var.peering_client_secret

  dns_zones = ["dev.platform.hmcts.net", "demo.platform.hmcts.net"]

  key_vault_name = "vh-infra-ado-dev-kv"

  route_table_name = "vh-infra-ado-dev-rt"

  vmss_name = "vh-infra-ado-dev-vmss"

  tags = {
    "environment"  = "development"
    "application"  = "vh-azure-devops-agent"
    "builtFrom"    = "hmcts/vh-azure-devops-agent"
    "businessArea" = "Cross-Cutting"
  }

  providers = {
    azurerm.current_peering = azurerm.current_peering
    azurerm.prod_peering    = azurerm.prod_peering
    azurerm.nonprod_peering = azurerm.nonprod_peering
    azurerm.sbox_peering    = azurerm.sbox_peering
    azurerm.mgmt_peering    = azurerm.mgmt_peering
    azurerm.dns             = azurerm.dns
    azurerm.image_gallery   = azurerm.image_gallery
  }

  depends_on = [
    azurerm_resource_group.vh_infra_core_ado
  ]
}