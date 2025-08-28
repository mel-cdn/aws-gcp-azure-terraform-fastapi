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

variable "container_image" {
  type = string
}

variable "container_arn" {
  type = string
}
