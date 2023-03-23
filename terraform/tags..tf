locals {
  tags = module.tags.common_tags
}

module "tags" {
  source      = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment = lower(var.environment)
  product     = "video-hearings-service"
  builtFrom   = "hmcts/vh-azure-devops-agent"
}