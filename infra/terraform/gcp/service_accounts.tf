resource "google_service_account" "api_service_account" {
  account_id   = "dm-api-sa"
  display_name = "Dunder Mifflin Service Account"
}

module "sa_roles" {
  source     = "./modules/service_account_roles"
  project_id = data.google_project.project.project_id
  roles = [
    "roles/storage.admin",
    "roles/datastore.user",
  ]
  email = google_service_account.api_service_account.email
}
