variable "billing_tags" {
  type        = map(string)
  description = "Tags for billing/cost allocation"
}

variable "region" {
  type = string
}

variable "resource_prefix" {
  type = string
}
