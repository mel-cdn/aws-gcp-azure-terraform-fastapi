locals {
  billing_tags = {
    environment = var.environment
    application = var.app_name
  }
  resource_prefix = "${var.infra}-${var.app_name}-${var.environment}"
  app_name_alnum  = lower(replace(var.app_name, "-", ""))
}

provider "aws" {
  region = var.region
}

# ----------------------------------------------------------------------------------------------------------------------
# App Service Image
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
  source                   = "./modules/app_runner_service"
  environment              = var.environment
  region                   = var.region
  resource_prefix          = local.resource_prefix
  repo_image_latest_digest = "${module.app_repo.url}:latest@${module.app_repo.image_latest_digest}"
  repo_image_arn           = module.app_repo.arn

  billing_tags = local.billing_tags

  depends_on = [module.app_repo]
}

# ----------------------------------------------------------------------------------------------------------------------
# Domain Mapping
# ----------------------------------------------------------------------------------------------------------------------
module "domain_mapping" {
  source                = "./modules/domain_mapping"
  apprunner_service_arn = module.app_service.arn
  domain_name           = "${var.environment != "prod" ? "${var.environment}." : ""}api.${local.app_name_alnum}.aws.${var.root_domain_name}"

  depends_on = [module.app_service]
}
