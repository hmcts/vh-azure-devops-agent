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

######################################################
# Peerings. ##########################################

data "azurerm_virtual_network" "hmcts-hub-nonprodi" {
  name                = "hmcts-hub-nonprodi"
  resource_group_name = "hmcts-hub-nonprodi"
  provider            = azurerm.nonprod_peer
}

data "azurerm_virtual_network" "ukw-hub-nonprodi" {
  name                = "ukw-hub-nonprodi"
  resource_group_name = "ukw-hub-nonprodi"
  provider            = azurerm.nonprod_peer
}

data "azurerm_virtual_network" "hmcts-hub-prod-int" {
  name                = "hmcts-hub-prod-int"
  resource_group_name = "hmcts-hub-prod-int"
  provider            = azurerm.prod_peer
}

data "azurerm_virtual_network" "hmcts-hub-sbox-int" {
  name                = "hmcts-hub-sbox-int"
  resource_group_name = "hmcts-hub-sbox-int"
  provider            = azurerm.sbox_peer
}

resource "azurerm_virtual_network_peering" "vh_infra_core_ado_TO_hubs" {
  for_each = {
    "hmcts-hub-nonprodi" = data.azurerm_virtual_network.hmcts-hub-nonprodi.id
    "ukw-hub-nonprodi"   = data.azurerm_virtual_network.ukw-hub-nonprodi.id
    "hmcts-hub-prod-int" = data.azurerm_virtual_network.hmcts-hub-prod-int.id
    "hmcts-hub-sbox-int" = data.azurerm_virtual_network.hmcts-hub-sbox-int.id
  }

  name                      = "vh-infra-core-ado-TO-${each.key}"
  resource_group_name       = azurerm_resource_group.vh_infra_core_ado.name
  virtual_network_name      = azurerm_virtual_network.vh_infra_core_ado.name
  remote_virtual_network_id = each.value
  provider                  = azurerm.stg_peer
}

# resource "azurerm_virtual_network_peering" "hubnonprod-to-agent" {
#   name                      = "hubnonprodtoagent"
#   resource_group_name       = "hmcts-hub-nonprodi"
#   virtual_network_name      = "hmcts-hub-nonprodi"
#   remote_virtual_network_id = azurerm_virtual_network.vh-devops-agent-vnet.id
# }