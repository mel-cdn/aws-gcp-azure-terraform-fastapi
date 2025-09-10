variable "billing_labels" {
  type        = map(string)
  description = "Labels for billing/cost allocation"
}

variable "environment" {
  type = string
}

variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "service_name" {
  type = string
}

variable "service_account_email" {
  type = string
}

variable "container_image_latest_digest" {
  type        = string
  description = <<EOT
Container image reference for the Cloud Run service.

- Use the fully qualified image with digest (<image>@<digest>) for immutable deployments
  (ensures Cloud Run only updates when the image content changes).
- Use a tag reference (<image>:latest or <image>:<tag>) if you want Cloud Run to redeploy
  whenever the tag is updated, but be aware this is not guaranteed to trigger a new revision.
EOT
}
