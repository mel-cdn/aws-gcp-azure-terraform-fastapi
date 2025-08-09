data "google_project" "project" {
  project_id = "${var.project_prefix}-${var.environment}"
}

locals {
  api_name = "${var.app_name}-api"
}

module "app_image" {
  source     = "./modules/docker_image"
  project_id = data.google_project.project.project_id
  region     = var.region
  image_name = "${local.api_name}-image"
}

module "app_service" {
  source              = "./modules/cloud_run_service"
  environment         = var.environment
  project_id          = data.google_project.project.project_id
  region              = var.region
  service_name        = local.api_name
  container_image_tag = module.app_image.tag

  depends_on = [module.app_image]
}
