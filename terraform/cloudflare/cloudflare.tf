terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.52.1"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.2.1"
    }
  }

  backend "s3" {
    bucket         = "terraform-state-aditya-thebe"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
    key            = "global/s3/cloudflare.tfstate"
    profile        = "personal"
    region         = "us-east-1"
  }
}

data "sops_file" "cloudflare_secrets" {
  source_file = "secret.sops.yaml"
}

provider "cloudflare" {
  api_token = data.sops_file.cloudflare_secrets.data["cloudflare_api_token"]
}
