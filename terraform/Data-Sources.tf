data "azurerm_resource_group" "dns" {
  name     = "core-infra-intsvc-rg"
  provider = azurerm.core_infra_dns
}

data "azurerm_resource_group" "dns_sandbox" {
  name     = "core-infra-intsvc-rg"
  provider = azurerm.sandbox_dns
}

data "azurerm_resource_group" "dns_reform" {
  name     = "vh-core-infra-test1"
  provider = azurerm.reform_dns
}