variable "billing_labels" {
  type        = map(string)
  description = "Labels for billing/cost allocation"
}

variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "cloud_run_service_name" {
  type = string
}

variable "domain_name" {
  type = string
}
