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