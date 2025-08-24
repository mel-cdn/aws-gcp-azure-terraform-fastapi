terraform {
  # backend "s3" {
  #   bucket         = "mel-pg-terraform-state"
  #   key            = "terraform.tfstate"
  #   # dynamodb_table = "mel-pg-terraform-state-lock"
  #   region         = "ap-southeast-1"
  #   # assume_role = {
  #   #   role_arn = "arn:aws:iam::x:role/xt/x-terraform-state-role"
  #   # }
  #   workspace_key_prefix =  "dm-inventory"
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.8.0"
    }
  }
}
