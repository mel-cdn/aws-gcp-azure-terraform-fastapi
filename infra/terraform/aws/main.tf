locals {
  billing_tags = {
    environment = var.environment
    application = var.app_name
  }

  api_name = "${var.app_name}-api"
}

provider "aws" {
  region = var.region
}

# ----------------------------------------------------------------------------------------------------------------------
# App Docker Image
# ----------------------------------------------------------------------------------------------------------------------
module "app_image" {
  source    = "./modules/container_registry"
  region    = var.region
  repo_name = "${var.infra}-${var.environment}/${local.api_name}-image"

  billing_tags = local.billing_tags
}

# ----------------------------------------------------------------------------------------------------------------------
# App Service
# ----------------------------------------------------------------------------------------------------------------------
module "app_service" {
  source          = "./modules/app_runner_service"
  environment     = var.environment
  region          = var.region
  resource_prefix = "${var.infra}-${var.environment}-${var.app_name}"
  service_name    = local.api_name
  container_image = "${module.app_image.repo_url}:latest"
  container_arn   = module.app_image.repo_arn

  billing_tags = local.billing_tags

  depends_on = [module.app_image]
}
