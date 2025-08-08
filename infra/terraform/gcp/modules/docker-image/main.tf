locals {
  working_dir = "${path.root}/../../../" # 3 levels up to the root where Docker requirements resides
  repo_name  = "docker-images"
  image_name = "${var.app_name}-image:latest"
  image_tag  = "${var.region}-docker.pkg.dev/${var.project_id}/${local.repo_name}/${local.image_name}"
}

data "google_artifact_registry_docker_image" "docker-image" {
  location      = google_artifact_registry_repository.docker-image-repo.location
  repository_id = google_artifact_registry_repository.docker-image-repo.repository_id
  image_name    = local.image_name

  depends_on = [
    null_resource.push-image
  ]
}

resource "google_project_service" "artifact-registry-api" {
  project            = var.project_id
  service            = "artifactregistry.googleapis.com"
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

resource "null_resource" "auth-docker" {
  provisioner "local-exec" {
    command = <<EOF
            gcloud auth configure-docker ${var.region}-docker.pkg.dev
        EOF
  }
  depends_on = [google_project_service.artifact-registry-api]
}

resource "null_resource" "build-image" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    working_dir = local.working_dir
    command     = <<EOF
        echo "> Extracting Python dependencies..."
        pipenv run pip freeze > requirements.txt

        echo "> Building docker image..."
        docker build --file=docker/Dockerfile -t ${local.image_tag} .
        EOF
  }
  depends_on = [null_resource.auth-docker]
}

resource "null_resource" "push-image" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    working_dir = local.working_dir
    command     = <<EOF
        echo "> Pushing app image..."
        docker push ${local.image_tag}
        EOF
  }
  depends_on = [null_resource.build-image, google_artifact_registry_repository.docker-image-repo]
}
