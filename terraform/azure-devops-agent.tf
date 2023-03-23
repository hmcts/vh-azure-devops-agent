module "agent" {
  source = "git::https://github.com/hmcts/terraform-module-azure-devops-agent.git?ref=v1.0.0"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  vnet_name          = var.vnet_name
  vnet_address_space = var.vnet_ip_address

  subnet_name           = var.subnet_name_vh_agent
  subnet_address_prefix = var.subnet_name_vh_agent_address

  peering_client_id     = var.peering_client_id
  peering_client_secret = var.peering_client_secret

  dns_zones = var.dns_zone

  key_vault_name = var.key_vault_name

  route_table_name = var.rt_name

  vmss_name = var.vmss_name

  nsg_name = var.nsg_name

  tags = local.tags

  providers = {
    azurerm.current_peering = azurerm.current_peering
    azurerm.prod_peering    = azurerm.prod_peering
    azurerm.nonprod_peering = azurerm.nonprod_peering
    azurerm.sbox_peering    = azurerm.sbox_peering
    azurerm.mgmt_peering    = azurerm.mgmt_peering
    azurerm.dns             = azurerm.dns
    azurerm.image_gallery   = azurerm.image_gallery
  }
}