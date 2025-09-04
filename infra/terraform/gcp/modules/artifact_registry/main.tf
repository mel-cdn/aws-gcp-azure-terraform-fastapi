terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
  required_version = "= 1.12.2"
}

locals {
  normalized_billing_labels = {
    for k, v in var.billing_labels : lower(k) => lower(v)
  }
  working_dir      = "${path.root}/../../../" # 3 levels up to the root where Docker requirements resides
  image_tag_prefix = "${var.region}-docker.pkg.dev/${var.project_id}/${var.repo_name}"

  image_tag        = "${local.image_tag_prefix}/${var.image_name}" # For cleanup old images
  image_tag_latest = "${local.image_tag_prefix}/${var.image_name}:latest"
}

# ----------------------------------------------------------------------------------------------------------------------
# Enable Artifact Registry API
# ----------------------------------------------------------------------------------------------------------------------
resource "google_project_service" "artifact-registry-api" {
  project            = var.project_id
  service            = "artifactregistry.googleapis.com"
  disable_on_destroy = false
}

# ----------------------------------------------------------------------------------------------------------------------
# Retrieve created resources for outputs
# ----------------------------------------------------------------------------------------------------------------------
data "google_artifact_registry_docker_image" "image" {
  location      = google_artifact_registry_repository.docker-image-repo.location
  repository_id = google_artifact_registry_repository.docker-image-repo.repository_id
  image_name    = "${var.image_name}:latest"

  depends_on = [
    null_resource.push-image
  ]
}

data "local_file" "image_digest" {
  filename = "${local.working_dir}digest.json"

  depends_on = [
    null_resource.push-image
  ]
}

# ----------------------------------------------------------------------------------------------------------------------
# Artifact Registry (Docker Repository)
# ----------------------------------------------------------------------------------------------------------------------
resource "google_artifact_registry_repository" "docker-image-repo" {
  repository_id = var.repo_name
  description   = "Repository for Docker Images"
  location      = var.region
  format        = "DOCKER"

  lifecycle {
    ignore_changes = []
  }

  labels     = local.normalized_billing_labels
  depends_on = [google_project_service.artifact-registry-api]
}

# ----------------------------------------------------------------------------------------------------------------------
# Build Docker image
# ----------------------------------------------------------------------------------------------------------------------
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

# ----------------------------------------------------------------------------------------------------------------------
# Push Docker image
# ----------------------------------------------------------------------------------------------------------------------
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

        echo "> Retrieving the image's latest digest..."
        DIGEST=$(docker inspect --format='{{index .RepoDigests 0}}' ${local.image_tag_latest} | cut -d'@' -f2)
        # Pass digest back to Terraform by writing to a triggers file
        echo "{ \"digest\": \"$DIGEST\" }" > digest.json
        EOF
  }
  depends_on = [null_resource.build-image, google_artifact_registry_repository.docker-image-repo]
}

# ----------------------------------------------------------------------------------------------------------------------
# Cleanup old Docker images
# ----------------------------------------------------------------------------------------------------------------------
resource "null_resource" "cleanup-old-images" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    working_dir = local.working_dir
    command     = <<EOF
        echo "> Cleaning up old app image (keep latest only)..."
        gcloud artifacts docker images list "${local.image_tag}" \
        --include-tags \
        --filter="tags!=latest" \
        | grep sha256 \
        | awk '{print $1 "@" $2}' \
        | xargs -I {} gcloud artifacts docker images delete {} \
        | true
        EOF
  }
  depends_on = [null_resource.push-image]
}
