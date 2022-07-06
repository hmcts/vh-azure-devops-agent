data "azurerm_resource_group" "dns" {
  name     = "core-infra-intsvc-rg"
  provider = azurerm.core_infra_dns
}

data "azurerm_resource_group" "dns_sandbox" {
  name     = "core-infra-intsvc-rg"
  provider = azurerm.sandbox_dns
}