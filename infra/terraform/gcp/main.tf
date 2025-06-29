terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}


resource "google_artifact_registry_repository" "my-repo" {
  repository_id = "docker-images"
  location      = var.region
  format        = "Docker"
  description   = "Repository for Docker images"
}
