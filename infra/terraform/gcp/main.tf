locals {
  billing_labels = {
    environment = var.environment
    application = var.app_name
  }
  project_id = "${var.project_prefix}-${var.environment}"
  api_name   = "${var.app_name}-api"
}

provider "google" {
  project = "${var.project_prefix}-${var.environment}"
  region  = var.region
}

# ----------------------------------------------------------------------------------------------------------------------
# App Service Image
# ----------------------------------------------------------------------------------------------------------------------
module "app_image" {
  source         = "./modules/artifact_registry"
  project_id     = local.project_id
  region         = var.region
  repo_name      = "docker-images"
  image_name     = "${local.api_name}-image"
  billing_labels = local.billing_labels
}

# ----------------------------------------------------------------------------------------------------------------------
# App Service
# ----------------------------------------------------------------------------------------------------------------------
module "app_service" {
  source                        = "./modules/cloud_run_service"
  environment                   = var.environment
  project_id                    = local.project_id
  region                        = var.region
  service_name                  = local.api_name
  service_account               = google_service_account.api_service_account.email
  container_image_latest_digest = "${module.app_image.latest_tag}@${module.app_image.latest_digest}"

  billing_labels = local.billing_labels

  depends_on = [module.app_image]
}

# ----------------------------------------------------------------------------------------------------------------------
# Domain Mapping
# ----------------------------------------------------------------------------------------------------------------------
module "domain_mapping" {
  source                 = "./modules/domain_mapping"
  project_id             = local.project_id
  region                 = var.region
  cloud_run_service_name = module.app_service.name
  domain_name            = "${var.environment != "prod" ? "${var.environment}." : ""}api.${var.app_name}.gcp.${var.root_domain_name}"

  billing_labels = local.billing_labels

  depends_on = [module.app_service]
}
