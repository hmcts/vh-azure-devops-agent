resource "azurerm_network_security_group" "vh_infra_core_ado_nsg" {
  name                = var.nsg_name
  location            = azurerm_resource_group.vh_infra_core_ado.location
  resource_group_name = azurerm_resource_group.vh_infra_core_ado.name
  tags                = local.common_tags
}

resource "azurerm_network_security_rule" "DenyAllInbound" {
  name                        = "DenyAll"
  priority                    = 4096
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.vh_infra_core_ado.name
  network_security_group_name = azurerm_network_security_group.vh_infra_core_ado_nsg.name
}
resource "azurerm_network_security_rule" "AllowBastion" {
  name                        = "AllowBastion"
  priority                    = 4095
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefixes     = ["10.11.8.0/23", "10.96.64.0/18"] # hub & core vnet address spaces 
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.vh_infra_core_ado.name
  network_security_group_name = azurerm_network_security_group.vh_infra_core_ado_nsg.name
}

resource "azurerm_subnet_network_security_group_association" "vh_infra_core_ado_nsg" {
  network_security_group_id = azurerm_network_security_group.vh_infra_core_ado_nsg.id
  subnet_id                 = azurerm_subnet.vh_infra_core_ado_snet.id
}