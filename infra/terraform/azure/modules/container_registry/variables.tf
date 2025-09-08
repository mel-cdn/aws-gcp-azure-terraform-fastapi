variable "billing_tags" {
  type        = map(string)
  description = "Tags for billing/cost allocation"
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type  = string
}

variable "resource_prefix" {
  type = string
}

variable "repo_name" {
  type = string
}
