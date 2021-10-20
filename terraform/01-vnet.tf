resource "azurerm_virtual_network" "vh-devops-agent-vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_ip_address
  location            = var.location
  resource_group_name = azurerm_resource_group.vh-devops-agent-rg.name
}

resource "azurerm_subnet" "vh-devops-agent-subnet" {
  name                 = var.subnet_name_vh_agent
  resource_group_name  = azurerm_resource_group.vh-devops-agent-rg.name
  virtual_network_name = azurerm_virtual_network.vh-devops-agent-vnet.name
  address_prefix       = var.subnet_name_vh_agent_address
}