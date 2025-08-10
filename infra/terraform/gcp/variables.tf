variable "project_prefix" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type    = string
  default = "asia-east1"
}

variable "app_name" {
  type    = string
  default = "dm-inventory"
}
