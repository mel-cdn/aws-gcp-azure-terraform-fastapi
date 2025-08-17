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

variable "service_account" {
  type = string
}

variable "container_image_tag" {
  type = string
}

variable "billing_labels" {
  type        = map(string)
  description = "Labels for billing/cost allocation"
}
