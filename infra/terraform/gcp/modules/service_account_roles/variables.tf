variable "project_id" {
  type = string
}

variable "roles" {
  type = list(string)
  description = "Refer to https://cloud.google.com/iam/docs/roles-overview"
}

variable "email" {
  type = string
}
