# Enable IAM API
resource "google_project_service" "iam-api" {
  project            = local.project_id
  service            = "iam.googleapis.com"
  disable_on_destroy = true
}

resource "google_service_account" "api_service_account" {
  account_id   = "dm-api-sa"
  display_name = "Dunder Mifflin API Service Account"

  depends_on = [google_project_service.iam-api]
}

module "sa_roles" {
  source     = "./modules/service_account_roles"
  project_id = local.project_id
  roles = [
    "roles/iam.serviceAccountUser",
  ]
  email = google_service_account.api_service_account.email
}
