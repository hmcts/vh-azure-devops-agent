data "azurerm_resource_group" "dns" {
  name     = "core-infra-intsvc-rg"
  provider = azurerm.current_sub_peer
}