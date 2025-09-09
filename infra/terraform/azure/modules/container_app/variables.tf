variable "billing_tags" {
  type        = map(string)
  description = "Tags for billing/cost allocation"
}

variable "resource_prefix" {
  type = string
}

variable "environment" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "container_registry_name" {
  type = string
}

variable "repo_image_latest_digest" {
  type = string
}
