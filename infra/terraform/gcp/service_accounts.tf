# Enable IAM API
resource "google_project_service" "cloud-run-api" {
  project            = local.project_id
  service            = "run.googleapis.com"
  disable_on_destroy = true
}

resource "google_service_account" "api_service_account" {
  account_id   = "dm-api-sa"
  display_name = "Dunder Mifflin API Service Account"
}

module "sa_roles" {
  source     = "./modules/service_account_roles"
  project_id = local.project_id
  roles = [
    "roles/storage.admin",
    "roles/datastore.user",
  ]
  email = google_service_account.api_service_account.email
}
