variable "billing_tags" {
  type        = map(string)
  description = "Tags for billing/cost allocation"
}

variable "resource_prefix" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}
