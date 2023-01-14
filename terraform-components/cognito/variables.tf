variable "aws_region" {
  default = "us-west-2"
}

variable "resource_server_identifier" {
  type    = string
  default = "products"
}

variable "resource_server_scopes" {
  type = map(string)
  default = {
    get_product    = "Read product details"
    create_product = "Create a new product"
    delete_product = "Delete a product"
  }
}