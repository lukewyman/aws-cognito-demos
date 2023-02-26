provider "aws" {
  region = var.aws_region
}

provider "okta" {
  org_name  = data.aws_ssm_parameter.okta_org_name
  base_url  = data.aws_ssm_parameter.okta_base_url
  api_token = data.aws_ssm_parameter.okta_token
}