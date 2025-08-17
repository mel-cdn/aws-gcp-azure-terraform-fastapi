variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "image_name" {
  type = string
}

variable "billing_labels" {
  type        = map(string)
  description = "Labels for billing/cost allocation"
}
