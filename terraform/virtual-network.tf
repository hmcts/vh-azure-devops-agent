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
  depends_on = [
    azurerm_virtual_network.vh_infra_core_ado
  ]
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

data "azurerm_virtual_network" "core-infra-vnet-mgmt" {
  name                = "core-infra-vnet-mgmt"
  resource_group_name = "rg-mgmt"
  provider            = azurerm.mgmt_peer
}

locals {
  ado_TO_hubs = var.env != "stg" ? {} : {
    "hmcts-hub-nonprodi"   = data.azurerm_virtual_network.hmcts-hub-nonprodi.id
    "ukw-hub-nonprodi"     = data.azurerm_virtual_network.ukw-hub-nonprodi.id
    "hmcts-hub-prod-int"   = data.azurerm_virtual_network.hmcts-hub-prod-int.id
    "hmcts-hub-sbox-int"   = data.azurerm_virtual_network.hmcts-hub-sbox-int.id
    "core-infra-vnet-mgmt" = data.azurerm_virtual_network.core-infra-vnet-mgmt.id
  }
}

resource "azurerm_virtual_network_peering" "vh_infra_core_ado_TO_hubs" {
  for_each = ado_TO_hubs

  name                      = "vh-infra-core-ado-TO-${each.key}"
  resource_group_name       = azurerm_resource_group.vh_infra_core_ado.name
  virtual_network_name      = azurerm_virtual_network.vh_infra_core_ado.name
  remote_virtual_network_id = each.value
  provider                  = azurerm.current_sub_peer
}

resource "azurerm_virtual_network_peering" "core-infra-vnet-mgmt_TO_vh_infra_core_ado" {
  count = var.env == "stg" ? 1 : 0

  name                      = "core-infra-vnet-mgmt-TO-${var.vnet_name}"
  resource_group_name       = data.azurerm_virtual_network.core-infra-vnet-mgmt.resource_group_name
  virtual_network_name      = data.azurerm_virtual_network.core-infra-vnet-mgmt.name
  remote_virtual_network_id = azurerm_virtual_network.vh_infra_core_ado.id
  provider                  = azurerm.mgmt_peer
  allow_forwarded_traffic   = true
}
resource "azurerm_virtual_network_peering" "hmcts_hub_nonprodi_TO_vh_infra_core_ado" {
  count = var.env == "stg" ? 1 : 0

  name                      = "hmcts-hub-nonprodi-TO-${var.vnet_name}"
  resource_group_name       = data.azurerm_virtual_network.hmcts-hub-nonprodi.resource_group_name
  virtual_network_name      = data.azurerm_virtual_network.hmcts-hub-nonprodi.name
  remote_virtual_network_id = azurerm_virtual_network.vh_infra_core_ado.id
  provider                  = azurerm.nonprod_peer
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "ukw_hub_nonprodi_TO_vh_infra_core_ado" {
  count = var.env == "stg" ? 1 : 0

  name                      = "ukw-hub-nonprodi-TO-${var.vnet_name}"
  resource_group_name       = data.azurerm_virtual_network.ukw-hub-nonprodi.resource_group_name
  virtual_network_name      = data.azurerm_virtual_network.ukw-hub-nonprodi.name
  remote_virtual_network_id = azurerm_virtual_network.vh_infra_core_ado.id
  provider                  = azurerm.nonprod_peer
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "hmcts-hub-prod-int_TO_vh_infra_core_ado" {
  count = var.env == "stg" ? 1 : 0

  name                      = "hmcts-hub-prod-int-TO-${var.vnet_name}"
  resource_group_name       = data.azurerm_virtual_network.hmcts-hub-prod-int.resource_group_name
  virtual_network_name      = data.azurerm_virtual_network.hmcts-hub-prod-int.name
  remote_virtual_network_id = azurerm_virtual_network.vh_infra_core_ado.id
  provider                  = azurerm.prod_peer
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "hmcts-hub-sbox-int_TO_vh_infra_core_ado" {
  count = var.env == "stg" ? 1 : 0

  name                      = "hmcts-hub-sbox-int-TO-${var.vnet_name}"
  resource_group_name       = data.azurerm_virtual_network.hmcts-hub-sbox-int.resource_group_name
  virtual_network_name      = data.azurerm_virtual_network.hmcts-hub-sbox-int.name
  remote_virtual_network_id = azurerm_virtual_network.vh_infra_core_ado.id
  provider                  = azurerm.sbox_peer
  allow_forwarded_traffic   = true
}

######################################################
# DNS to VNET Link. ##########################################
resource "azurerm_private_dns_zone_virtual_network_link" "vnet_to_dns" {
  for_each              = toset(var.dns_zone)
  provider              = azurerm.core_infra_dns
  name                  = azurerm_virtual_network.vh_infra_core_ado.name
  resource_group_name   = data.azurerm_resource_group.dns.name
  private_dns_zone_name = each.value
  virtual_network_id    = azurerm_virtual_network.vh_infra_core_ado.id
  tags                  = local.common_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_to_dns_sandbox" {
  for_each              = toset(var.dns_zone_sandbox)
  provider              = azurerm.sandbox_dns
  name                  = azurerm_virtual_network.vh_infra_core_ado.name
  resource_group_name   = data.azurerm_resource_group.dns_sandbox.name
  private_dns_zone_name = each.value
  virtual_network_id    = azurerm_virtual_network.vh_infra_core_ado.id
  tags                  = local.common_tags
}




######################################################
# Route Table & Subnet-RT Link. ##########################################

resource "azurerm_route_table" "agent-rt" {
  name                          = var.rt_name
  location                      = var.location
  resource_group_name           = azurerm_resource_group.vh_infra_core_ado.name
  disable_bgp_route_propagation = false
  tags                          = local.common_tags

  dynamic "route" {
    for_each = var.route_table.route
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = route.value.next_hop_in_ip_address
    }
  }
}
resource "azurerm_subnet_route_table_association" "sub_rt" {
  subnet_id      = azurerm_subnet.vh_infra_core_ado_snet.id
  route_table_id = azurerm_route_table.agent-rt.id
}