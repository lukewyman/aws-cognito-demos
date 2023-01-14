resource "aws_cognito_user_pool" "product_user_pool" {
  name = "${local.app_prefix}${terraform.workspace}-pool"

  username_attributes      = ["email"]
  auto_verified_attributes = ["email"]
  password_policy {
    minimum_length = 6
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject        = "Account Confirmation"
    email_message        = "Your confirmation code is {####}"
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }
}

resource "aws_cognito_user_pool_domain" "user_pool_domain" {
  domain       = random_string.domain_pool_name.result
  user_pool_id = aws_cognito_user_pool.product_user_pool.id
}

resource "random_string" "domain_pool_name" {
  length  = 12
  numeric = false
  special = false
  upper   = false
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name                                 = "${local.app_prefix}${terraform.workspace}-client"
  user_pool_id                         = aws_cognito_user_pool.product_user_pool.id
  allowed_oauth_flows                  = ["client_credentials"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes = [for k, v in var.resource_server_scopes : "${var.resource_server_identifier}/${k}"]
  generate_secret              = true
  supported_identity_providers = ["COGNITO"]

  depends_on = [aws_cognito_resource_server.resource_server]
}

resource "aws_cognito_resource_server" "resource_server" {
  name         = "${local.app_prefix}${terraform.workspace}"
  identifier   = var.resource_server_identifier
  user_pool_id = aws_cognito_user_pool.product_user_pool.id

  dynamic "scope" {
    for_each = var.resource_server_scopes
    content {
      scope_name        = scope.key
      scope_description = scope.value
    }
  }
}