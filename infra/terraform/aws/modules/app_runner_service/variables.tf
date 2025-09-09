variable "billing_tags" {
  type        = map(string)
  description = "Tags for billing/cost allocation"
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "resource_prefix" {
  type = string
}

variable "repo_image_latest_digest" {
  type = string
}

variable "repo_image_arn" {
  type = string
}
