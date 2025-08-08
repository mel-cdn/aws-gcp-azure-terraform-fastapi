data "google_project" "project" {
  project_id = "${var.project_prefix}-${var.environment}"
}

module "app_image" {
  source     = "./modules/docker-image"
  project_id = data.google_project.project.project_id
  region     = var.region
  app_name   = var.app_name
}
