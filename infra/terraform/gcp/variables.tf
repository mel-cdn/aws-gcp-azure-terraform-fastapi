variable "project_prefix" {
  type = string
}

variable "region" {
  type    = string
  default = "asia-east1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "app_name" {
  type    = string
  default = "dm-inventory"
}
