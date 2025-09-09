variable "project_prefix" {
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

variable "environment" {
  type    = string
  default = "dev"
}

variable "root_domain_name" {
  type        = string
  description = <<EOT
The base domain name you have registered.

- Example: mydomain.com
- Full domain URLs will follow the pattern: <environment>.api.<app_name>.gcp.mydomain.com
EOT
}
