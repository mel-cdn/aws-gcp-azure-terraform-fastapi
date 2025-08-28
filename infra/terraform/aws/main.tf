locals {
  billing_tags = {
    environment = var.environment
    application = var.app_name
  }
  resource_prefix = "${var.infra}-${var.app_name}-${var.environment}"
}

provider "aws" {
  region = var.region
}

# ----------------------------------------------------------------------------------------------------------------------
# App Docker Image
# ----------------------------------------------------------------------------------------------------------------------
module "app_repo" {
  source          = "./modules/container_registry"
  region          = var.region
  resource_prefix = local.resource_prefix

  billing_tags = local.billing_tags
}


# ----------------------------------------------------------------------------------------------------------------------
# App Service
# ----------------------------------------------------------------------------------------------------------------------
module "app_service" {
  source          = "./modules/app_runner_service"
  environment     = var.environment
  region          = var.region
  resource_prefix = local.resource_prefix
  container_image = "${module.app_repo.url}:latest"
  container_arn   = module.app_repo.arn

  billing_tags = local.billing_tags

  depends_on = [module.app_repo]
}
