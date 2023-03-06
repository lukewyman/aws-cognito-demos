data "aws_caller_identity" "current" {}

# Look up the ARNs for the Lambdas in the "Lambdas for Coginito" project
data "terraform_remote_state" "lambdas_for_cognito" {
  backend = "remote"

  config = {
    organization = "spikes"
    workspaces = {
      name = "apigw-cognito-oauth2-lambda-${terraform.workspace}"
    }
  }
}

data "template_file" "products_api" {

  template = file("${path.module}/../../demo-apps/oauth2-apigw-cognito/apigw/oauth2-cognito-openapi.yml")

  vars = {
    account_id              = data.aws_caller_identity.current.account_id
    aws_region              = var.aws_region
    lambda_identity_timeout = 5000 # var.lambda_identity_timeout

    create_product_arn = data.terraform_remote_state.lambdas_for_cognito.outputs.lambdas["create-product"]["arn"]
    get_product_arn    = data.terraform_remote_state.lambdas_for_cognito.outputs.lambdas["get-product"]["arn"]
    delete_product_arn = data.terraform_remote_state.lambdas_for_cognito.outputs.lambdas["delete-product"]["arn"]

    user_pool_arn = var.user_pool_arn
  }
}

