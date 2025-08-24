locals {
  billing_tags = {
    Environment = var.environment
    Application = var.app_name
  }

  namespace = "${var.infra}-${var.environment}"
  api_name  = "${var.app_name}-api"
}

provider "aws" {
  region = var.region
}

module "app_image" {
  source       = "./modules/container_registry"
  region       = var.region
  repo_name    = "${local.namespace}/${local.api_name}-image"
  billing_tags = local.billing_tags
}
