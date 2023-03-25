locals {
  tags = module.tags.common_tags
}

module "tags" {
  source      = "git::https://github.com/hmcts/terraform-module-common-tags.git?ref=master"
  environment = lower(var.env)
  product     = "vh"
  builtFrom   = "hmcts/vh-azure-devops-agent"
}