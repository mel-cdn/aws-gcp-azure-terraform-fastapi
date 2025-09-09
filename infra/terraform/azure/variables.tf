variable "location" {
  type    = string
  default = "southeastasia" # nearest to Philippines
}

variable "infra" {
  type    = string
  default = "playground"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "app_name" {
  type    = string
  default = "dm-inventory"
}

# variable "root_domain_name" {
#   type        = string
#   description = <<EOT
# The base domain name you have registered.
#
# - Example: mydomain.com
# - Full domain URLs will follow the pattern: <environment>.api.<app_name>.azure.mydomain.com
# EOT
# }
