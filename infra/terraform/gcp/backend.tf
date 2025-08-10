terraform {
  # Delete block if you will not use GCS as backend
  backend "gcs" {
    bucket = "mel-pg-terraform-state"
    prefix = "dm-inventory"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}
