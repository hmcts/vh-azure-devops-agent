locals {
  common_tags = module.tags.common_tags
}

module "tags" {
  source      = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment = "staging"
  product     = "video-hearing-service"
  builtFrom   = "hmcts/vh-azure-devops-agent"
}