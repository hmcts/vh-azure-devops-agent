resource "azurerm_virtual_network" "vh-devops-agent-vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_ip_address
  location            = var.location
  resource_group_name = azurerm_resource_group.vh-devops-agent-rg.name
  tags                = local.common_tags
}

resource "azurerm_subnet" "vh-devops-agent-subnet" {
  name                 = var.subnet_name_vh_agent
  resource_group_name  = azurerm_resource_group.vh-devops-agent-rg.name
  virtual_network_name = azurerm_virtual_network.vh-devops-agent-vnet.name
  address_prefixes     = [var.subnet_name_vh_agent_address]
}

resource "azurerm_virtual_network_peering" "agent-to-hubnonprod" {
  name                      = "agenttohubnonprod"
  resource_group_name       = azurerm_resource_group.vh-devops-agent-rg.name
  virtual_network_name      = var.vnet_name
  remote_virtual_network_id = "/subscriptions/fb084706-583f-4c9a-bdab-949aac66ba5c/resourceGroups/hmcts-hub-nonprodi/providers/Microsoft.Network/virtualNetworks/hmcts-hub-nonprodi"
}

resource "azurerm_virtual_network_peering" "hubnonprod-to-agent" {
  name                      = "hubnonprodtoagent"
  resource_group_name       = "hmcts-hub-nonprodi"
  virtual_network_name      = "hmcts-hub-nonprodi"
  remote_virtual_network_id = azurerm_virtual_network.vh-devops-agent-vnet.id
}