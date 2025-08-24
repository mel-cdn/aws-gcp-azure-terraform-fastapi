locals {
  billing_labels = {
    Environment = var.environment
    Application = var.app_name
  }
  project_id = "${var.project_prefix}-${var.environment}"
  api_name   = "${var.app_name}-api"
}

provider "google" {
  project = "${var.project_prefix}-${var.environment}"
  region  = var.region
}

module "app_image" {
  source         = "./modules/artifact_registry"
  project_id     = local.project_id
  region         = var.region
  repo_name      = "docker-images"
  image_name     = "${local.api_name}-image"
  billing_labels = local.billing_labels
}

module "app_service" {
  source          = "./modules/cloud_run_service"
  environment     = var.environment
  project_id      = local.project_id
  region          = var.region
  service_name    = local.api_name
  service_account = google_service_account.api_service_account.email
  container_image = "${module.app_image.tag}@${module.app_image.latest_digest}"

  billing_labels = local.billing_labels

  depends_on = [module.app_image]
}
