variable "region" {
  type    = string
  default = "ap-southeast-1"
}

variable "infra" {
  type    = string
  default = "playground"
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
- Full domain URLs will follow the pattern: <environment>.api.<app_name>.aws.mydomain.com
EOT
}
