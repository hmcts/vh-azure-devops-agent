build_resource_group_name = "vh-infra-core-ado"
gallery_name              = "vhinfracoreado"
tags = {
  environment  = "Staging"
  criticality  = "Low"
  builtFrom    = "hmcts/vh-azure-devops-agent"
  application  = "video-hearing-service"
  businessArea = "Cross-Cutting"
}