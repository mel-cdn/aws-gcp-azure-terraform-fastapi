variable "apprunner_service_arn" {
  type = string
}

variable "domain_name" {
  type        = string
  description = <<EOT
  Full domain name
- Example: dev.sub.domain.mydomain.com
EOT
}
