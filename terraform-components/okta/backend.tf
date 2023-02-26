terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "spikes"

    workspaces {
      prefix = "aws-cognito-demos-okta-"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.19.0"
    }

    okta = {
      source  = "okta/okta"
      version = "~> 3.37"
    }
  }
}