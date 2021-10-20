resource "azurerm_network_security_group" "vh-devops-agent-nsg" {
  name                = var.nsg_name
  location            = azurerm_resource_group.vh-devops-agent-rg.location
  resource_group_name = azurerm_resource_group.vh-devops-agent-rg.name
}

resource "azurerm_network_security_rule" "example" {
  name                        = "ssh-allow"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "1.2.3.4"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.vh-devops-agent-rg.name
  network_security_group_name = azurerm_network_security_group.vh-devops-agent-nsg.name
}

resource "azurerm_network_interface_security_group_association" "vh-devops-agent-nic-nsg" {
  network_interface_id      = azurerm_network_interface.vh-devops-nic.id
  network_security_group_id = azurerm_network_security_group.vh-devops-agent-nsg.id
}