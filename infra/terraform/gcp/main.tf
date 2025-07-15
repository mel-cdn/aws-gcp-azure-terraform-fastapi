data "google_project" "project" {
  project_id = var.project_id
}

module "docker" {
  source     = "./modules/docker-image"
  project_id = data.google_project.project.project_id
  location   = var.location
  app_name   = var.app_name

}
