
locals {
  pips = var.env == "dev" ? local.vms : {}
}

resource "azurerm_public_ip" "dev_pip" {
  for_each = local.pips

  name                = "devPip=${each.value.name}"
  resource_group_name = azurerm_resource_group.vh_infra_core_ado.name
  location            = azurerm_resource_group.vh_infra_core_ado.location
  allocation_method   = "Static"


  tags = local.common_tags
}