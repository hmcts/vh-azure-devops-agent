resource "azurerm_network_security_group" "vh_infra_core_ado_nsg" {
  name                = var.nsg_name
  location            = azurerm_resource_group.vh_infra_core_ado.location
  resource_group_name = azurerm_resource_group.vh_infra_core_ado.name
  tags                = local.common_tags
}

# resource "azurerm_network_security_rule" "DenyVnetInbound" {
#   name                        = "DenyVnetInbound"
#   priority                    = 4096
#   direction                   = "Inbound"
#   access                      = "Deny"
#   protocol                    = "*"
#   source_port_range           = "*"
#   destination_port_range      = "*"
#   source_address_prefix       = "VirtualNetwork"
#   destination_address_prefix  = "VirtualNetwork"
#   resource_group_name         = azurerm_resource_group.vh_infra_core_ado.name
#   network_security_group_name = azurerm_network_security_group.vh_infra_core_ado_nsg.name
# }


resource "azurerm_subnet_network_security_group_association" "vh_infra_core_ado_nsg" {
  network_security_group_id = azurerm_network_security_group.vh_infra_core_ado_nsg.id
  subnet_id                 = azurerm_subnet.vh_infra_core_ado_snet.id
}