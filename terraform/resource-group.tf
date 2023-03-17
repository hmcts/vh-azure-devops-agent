resource "azurerm_resource_group" "vh_infra_core_ado" {
  name     = var.rg_name
  location = var.location
  tags = {
    "environment"  = "development"
    "application"  = "vh-azure-devops-agent"
    "builtFrom"    = "hmcts/vh-azure-devops-agent"
    "businessArea" = "Cross-Cutting"
  }
}

data "azurerm_client_config" "current" {}