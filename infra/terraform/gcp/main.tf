resource "google_artifact_registry_repository" "docker_image_repo" {
  repository_id = "docker-images"
  location      = var.location
  format        = "Docker"
  description   = "Repository for Docker images"

  lifecycle {
    ignore_changes = []
  }
}

data "google_artifact_registry_docker_image" "service_image" {
  location      = google_artifact_registry_repository.docker_image_repo.location
  repository_id = google_artifact_registry_repository.docker_image_repo.repository_id
  image_name    = "${var.service_name}-image"
}
