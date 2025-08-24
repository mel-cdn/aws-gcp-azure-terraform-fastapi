variable "region" {
  type = string
}

variable "repo_name" {
  type = string
}

variable "billing_tags" {
  type        = map(string)
  description = "Labels for billing/cost allocation"
}
