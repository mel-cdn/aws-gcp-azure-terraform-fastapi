variable "region" {
  type    = string
  default = "ap-southeast-1"
}

variable "infra" {
  type        = string
  description = "playground"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "app_name" {
  type    = string
  default = "dm-inventory"
}
