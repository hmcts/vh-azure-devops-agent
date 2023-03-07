build_resource_group_name = "vh-infra-ado-dev-rg"
gallery_name              = "vh_infra_core_dev_gal"
tags = {
  environment  = "Development"
  criticality  = "Low"
  builtFrom    = "hmcts/vh-azure-devops-agent"
  application  = "video-hearing-service"
  businessArea = "Cross-Cutting"
}