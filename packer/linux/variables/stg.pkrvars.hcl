build_resource_group_name = "vh-infra-ado-stg-rg"
gallery_name              = "vh_infra_ado_stg_gal"
tags = {
  environment  = "Staging"
  criticality  = "Low"
  builtFrom    = "hmcts/vh-azure-devops-agent"
  application  = "video-hearing-service"
  businessArea = "Cross-Cutting"
}