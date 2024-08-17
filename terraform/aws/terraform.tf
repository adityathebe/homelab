terraform {
  required_version = ">= 1.9.0"

  backend "s3" {
    bucket         = "terraform-state-aditya-thebe"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
    key            = "global/s3/s3.tfstate"
    profile        = "personal"
    region         = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
