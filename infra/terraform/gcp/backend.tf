terraform {
  # Delete block if you will not use GCS as backend
  backend "gcs" {
    bucket = "" # Will be populated on deploy or add it manually here.
    prefix = "dm-inventory"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
  required_version = "= 1.12.2"
}
