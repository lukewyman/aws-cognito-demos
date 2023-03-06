variable "aws_region" {
  default = "us-west-2"
}

variable "the_lambdas" {
  type = list(string)
  default = [
    "create-product",
    "delete-product",
    "get-product"
  ]
}

variable "user_pool_arn" {
  description = "ARN for Cognito User Pool to secure the API"
  type = string 
  default = "arn:aws:cognito-idp:us-west-2:919980474747:userpool/us-west-2_tGTXr24zv"
}