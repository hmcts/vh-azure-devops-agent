build_resource_group_name = "vh-infra-ado-dev"
gallery_name              = "vhinfracoreado"
tags = {
  environment  = "Development"
  criticality  = "Low"
  builtFrom    = "hmcts/vh-azure-devops-agent"
  application  = "video-hearing-service"
  businessArea = "Cross-Cutting"
}