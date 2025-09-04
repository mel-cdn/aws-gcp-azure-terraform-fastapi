terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
  required_version = ">= 1.2.0"
}

locals {
  normalized_billing_labels = {
    for k, v in var.billing_labels : lower(k) => lower(v)
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# Enable Cloud Run API
# ----------------------------------------------------------------------------------------------------------------------
resource "google_project_service" "cloud-run-api" {
  project            = var.project_id
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

# ----------------------------------------------------------------------------------------------------------------------
# Create Cloud Run Service
# ----------------------------------------------------------------------------------------------------------------------
resource "google_cloud_run_v2_service" "service" {
  name                = var.service_name
  location            = var.region
  deletion_protection = false
  ingress             = "INGRESS_TRAFFIC_ALL"

  template {
    service_account                  = var.service_account
    timeout                          = "120s"
    max_instance_request_concurrency = 1
    containers {
      image = var.container_image
      ports {
        container_port = 8080
      }
      resources {
        limits = {
          cpu    = "1"
          memory = "512Mi"
        }
      }
      env {
        name  = "ENVIRONMENT"
        value = var.environment
      }
      env {
        name  = "LOG_LEVEL"
        value = "DEBUG"
      }
    }
    scaling {
      max_instance_count = 1
      min_instance_count = 0
    }
  }
  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }

  labels     = local.normalized_billing_labels
  depends_on = [google_project_service.cloud-run-api]
}

# ----------------------------------------------------------------------------------------------------------------------
# Set Authentication
# ----------------------------------------------------------------------------------------------------------------------
resource "google_cloud_run_service_iam_member" "authentication" {
  location = google_cloud_run_v2_service.service.location
  project  = google_cloud_run_v2_service.service.project
  service  = google_cloud_run_v2_service.service.name

  role   = "roles/run.invoker"
  member = "allUsers"

  depends_on = [google_cloud_run_v2_service.service]
}
