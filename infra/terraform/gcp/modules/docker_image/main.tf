locals {
  working_dir = "${path.root}/../../../" # 3 levels up to the root where Docker requirements resides
  repo_name         = "docker-images"
  image_name_latest = "${var.image_name}:latest"
  image_tag_prefix  = "${var.region}-docker.pkg.dev/${var.project_id}/${local.repo_name}"
  image_tag         = "${local.image_tag_prefix}/${var.image_name}"
  image_tag_latest  = "${local.image_tag_prefix}/${local.image_name_latest}"
}

# Enable Artifact Registry API
resource "google_project_service" "artifact-registry-api" {
  project            = var.project_id
  service            = "artifactregistry.googleapis.com"
  disable_on_destroy = true
}

data "google_artifact_registry_docker_image" "image" {
  location      = google_artifact_registry_repository.docker-image-repo.location
  repository_id = google_artifact_registry_repository.docker-image-repo.repository_id
  image_name    = local.image_name_latest

  depends_on = [
    null_resource.push-image
  ]
}

resource "google_artifact_registry_repository" "docker-image-repo" {
  repository_id = local.repo_name
  description   = "Repository for Docker Images"
  location      = var.region
  format        = "DOCKER"

  cleanup_policies {
    id     = "keep-lastest-2-versions-only"
    action = "KEEP"
    most_recent_versions {
      package_name_prefixes = [var.image_name]
      keep_count = 2
    }
  }

  lifecycle {
    ignore_changes = []
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
        pipenv requirements --categories default > requirements.txt

        echo "> Building docker image..."
        docker build --platform linux/amd64 --file=docker/Dockerfile -t ${local.image_tag_latest} .
        EOF
  }
  depends_on = [google_project_service.artifact-registry-api]
}

resource "null_resource" "push-image" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    working_dir = local.working_dir
    command     = <<EOF
        echo "> Authenticating to Artifact Registry..."
        gcloud auth configure-docker ${var.region}-docker.pkg.dev

        echo "> Pushing app image..."
        docker push ${local.image_tag_latest}
        EOF
  }
  depends_on = [null_resource.build-image, google_artifact_registry_repository.docker-image-repo]
}

# resource "null_resource" "cleanup-old-images" {
#   triggers = {
#     always_run = timestamp()
#   }
#
#   provisioner "local-exec" {
#     working_dir = local.working_dir
#     command     = <<EOF
#         echo "> Cleaning up old app image..."
#         gcloud artifacts docker images list "${local.image_tag}" \
#         --include-tags \
#         --filter="tags!=latest" \
#         | grep sha256 \
#         | awk '{print $1 "@" $2}' \
#         | xargs -I {} gcloud artifacts docker images delete {} \
#         | true
#         EOF
#   }
#   depends_on = [null_resource.push-image]
# }
