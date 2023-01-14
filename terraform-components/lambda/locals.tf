locals {

  tags = {
    created_by = "terraform"
  }

  app_prefix = "aws-cognito-demos-lambda-"

  aws_ecr_url = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
}