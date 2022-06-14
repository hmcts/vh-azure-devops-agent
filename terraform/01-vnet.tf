resource "azurerm_virtual_network" "vh_infra_core_ado" {
  name                = var.vnet_name
  address_space       = var.vnet_ip_address
  location            = var.location
  resource_group_name = azurerm_resource_group.vh_infra_core_ado.name
  tags                = local.common_tags
}

resource "azurerm_subnet" "vh_infra_core_ado_snet" {
  name                 = var.subnet_name_vh_agent
  resource_group_name  = azurerm_resource_group.vh_infra_core_ado.name
  virtual_network_name = azurerm_virtual_network.vh_infra_core_ado.name
  address_prefixes     = [var.subnet_name_vh_agent_address]
}