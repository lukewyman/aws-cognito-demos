resource "aws_ecr_repository" "image_repo" {
  for_each = var.lambda_params

  name = "${local.app_prefix}${terraform.workspace}-${each.key}"
}

resource "docker_registry_image" "image" {
  for_each = var.lambda_params

  name = "${aws_ecr_repository.image_repo[each.key].repository_url}:${each.value["image-tag"]}"

  build {
    context    = "${path.module}/../../demo-apps/artifacts/lambda/${each.value["context"]}"
    dockerfile = "Dockerfile"
  }
}

resource "aws_iam_role" "lambda_role" {
  for_each = var.lambda_params

  name               = "${local.app_prefix}${terraform.workspace}-${each.key}-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_policy" "lambda_logging_policy" {
  name   = "${local.app_prefix}${terraform.workspace}-lambda-logging-policy"
  policy = data.aws_iam_policy_document.lambda_logging_policy.json
}

resource "aws_iam_role_policy_attachment" "logging_policy_attachment" {
  for_each = var.lambda_params

  role       = aws_iam_role.lambda_role[each.key].name
  policy_arn = aws_iam_policy.lambda_logging_policy.arn
}

resource "aws_iam_policy" "lambda_dynamodb_policy" {
  name   = "${local.app_prefix}${terraform.workspace}-lambda-dynamodb-policy"
  policy = data.aws_iam_policy_document.lambda_dynamodb_policy.json
}

resource "aws_iam_role_policy_attachment" "dynamodb_policy_attachment" {
  for_each = var.lambda_params

  role       = aws_iam_role.lambda_role[each.key].name
  policy_arn = aws_iam_policy.lambda_dynamodb_policy.arn
}

resource "aws_lambda_function" "lambda_function" {
  for_each = var.lambda_params

  function_name = "${local.app_prefix}${terraform.workspace}-${each.key}"
  role          = aws_iam_role.lambda_role[each.key].arn
  timeout       = var.lambda_timeout
  image_uri = docker_registry_image.image[each.key].name 
  package_type = "Image"

  environment {
    variables = {
      PRODUCTS_TABLE_NAME = aws_dynamodb_table.products.name
    }
  }
}

resource "aws_cloudwatch_log_group" "lambda_logs_group" {
  for_each = var.lambda_params 

  name = "/aws/lambda/${aws_lambda_function.lambda_function[each.key].function_name}"
}

resource "aws_dynamodb_table" "products" {
  name = "${local.app_prefix}${terraform.workspace}-products"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "product_id"

  attribute {
    name = "product_id"
    type = "S"
  }
}