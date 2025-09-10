terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
  required_version = ">= 1.2.0"
}

# ----------------------------------------------------------------------------------------------------------------------
# Enable IAM API
# ----------------------------------------------------------------------------------------------------------------------
resource "google_project_service" "iam-api" {
  project            = var.project_id
  service            = "iam.googleapis.com"
  disable_on_destroy = true
}

# ----------------------------------------------------------------------------------------------------------------------
# App Service Account
# ----------------------------------------------------------------------------------------------------------------------
resource "google_service_account" "sa" {
  account_id   = var.service_account_name
  display_name = "Dunder Mifflin API Service Account"

  depends_on = [google_project_service.iam-api]
}

# ----------------------------------------------------------------------------------------------------------------------
# Role Assignment
# ----------------------------------------------------------------------------------------------------------------------
resource "google_project_iam_member" "sa_roles" {
  for_each = toset(var.roles)

  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.sa.email}"
}
