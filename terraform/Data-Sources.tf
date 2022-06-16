data "azurerm_resource_group" "dns" {
  name     = "core-infra-intsvc-rg"
  provider = azurerm.core_infra_dns
}