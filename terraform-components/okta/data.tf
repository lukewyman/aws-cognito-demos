data "aws_ssm_parameter" "okta_base_url" {
  name = "/tool/okta/BASE_URL"
}

data "aws_ssm_parameter" "okta_org_name" {
  name = "/tool/okta/ORG_NAME"
}

data "aws_ssm_parameter" "okta_token" {
  name            = "/tool/okta/TOKEN"
  with_decryption = true
}