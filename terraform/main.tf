# module "ado_agent" {
#   source = "git::https://github.com/hmcts/cnp-terraform-module-azure-devops-agent.git?ref=VIH-9741"

#   resource_group_name = var.rg_name
#   location            = var.location

#   vnet_name          = var.vnet_name
#   vnet_address_space = var.vnet_ip_address

#   subnet_name           = var.subnet_name_vh_agent
#   subnet_address_prefix = var.subnet_name_vh_agent_address

#   peering_client_id     = var.peering_client_id
#   peering_client_secret = var.peering_client_secret

#   tags = {
#     "environment"  = "development"
#     "application"  = "vh-azure-devops-agent"
#     "builtFrom"    = "hmcts/vh-azure-devops-agent"
#     "businessArea" = "Cross-Cutting"
#   }
# }