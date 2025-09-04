terraform {
  backend "s3" {
    region = "ap-southeast-1"
    key    = "default.tfstate"

    # Will be populated on deploy or add it manually here
    bucket         = ""
    dynamodb_table = ""

    workspace_key_prefix = "dm-inventory"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.8.0"
    }
  }

  required_version = "= 1.12.2"
}
