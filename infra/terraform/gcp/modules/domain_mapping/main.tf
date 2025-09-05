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
# Domain Mapping
# ----------------------------------------------------------------------------------------------------------------------
resource "google_cloud_run_domain_mapping" "domain" {
  location = var.region
  name     = var.domain_name

  spec {
    route_name = var.cloud_run_service_name
  }

  metadata {
    namespace = var.project_id
    labels    = local.normalized_billing_labels
  }
}
