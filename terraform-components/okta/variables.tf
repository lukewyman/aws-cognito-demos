variable "aws_region" {
  default = "us-west-2"
}

variable "okta_base_url" {
  type        = string
  description = "Okta base url"
  default     = "okta.com"
}

variable "okta_org_name" {
  type        = string
  description = "Okta org name"
  default     = "UNSET"
}

variable "okta_token" {
  type        = string
  description = "Okta token"
  default     = "UNSET"
}