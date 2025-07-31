locals {
  repo_name  = "docker-images"
  image_name = "${var.app_name}-image:latest"
  image_tag  = "${var.region}-docker.pkg.dev/${var.project_id}/${local.repo_name}/${local.image_name}"
}


resource "google_project_service" "artifact-registry-api" {
  project            = var.project_id
  service            = "containerregistry.googleapis.com"
  disable_on_destroy = true
}


resource "google_artifact_registry_repository" "docker-image-repo" {
  repository_id = local.repo_name
  description   = "Repository for Docker Images"
  location      = var.region
  format        = "DOCKER"

  lifecycle {
    ignore_changes = []
  }
  depends_on = [google_project_service.artifact-registry-api]
}
#
# data "google_artifact_registry_docker_image" "docker-image" {
#   location      = google_artifact_registry_repository.docker-image-repo.location
#   repository_id = google_artifact_registry_repository.docker-image-repo.repository_id
#   image_name    = local.image_name
# }
#
#
resource "null_resource" "auth-docker" {
  provisioner "local-exec" {
    command = <<EOF
            gcloud auth configure-docker ${var.region}-docker.pkg.dev
        EOF
  }
}
#
# resource "null_resource" "build-image" {
#   triggers = {
#     always_run = "${timestamp()}"
#   }
#   provisioner "local-exec" {
#     command = <<EOF
#             docker build -t --file=docker/Dockerfile -t  ${local.docker_image_name} .. ${local.build_args}
#         EOF
#   }
#   depends_on = [null_resource.auth-docker]
# }
#
# resource "null_resource" "push_image" {
#   triggers = {
#     always_run = "${timestamp()}"
#   }
#   provisioner "local-exec" {
#     command = <<EOF
#             docker push ${local.artifact_image_name}
#         EOF
#   }
#   depends_on = [null_resource.build-image]
# }
