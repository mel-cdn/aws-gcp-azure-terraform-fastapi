variable "project_id" {
  type = string
}

variable "roles" {
  type        = list(string)
  description = "Refer to https://cloud.google.com/iam/docs/roles-overview"
}

variable "service_account_name" {
  type = string
}
