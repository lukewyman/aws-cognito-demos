variable "aws_region" {
  default = "us-west-2"
}

variable "lambda_params" {
  description = "Map of lambda names and their corresponding directory names"
  type        = map(map(string))
  default = {
    create-product = {
      context   = "create_product"
      image-tag = 1
    }
    delete-product = {
      context   = "delete_product"
      image-tag = 1
    }
    get-product = {
      context   = "get_product"
      image-tag = 1
    }
  }
}

variable "lambda_timeout" {
  default = 5
}