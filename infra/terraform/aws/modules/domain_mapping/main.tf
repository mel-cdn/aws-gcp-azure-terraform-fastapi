terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.8.0"
    }
  }
  required_version = ">= 1.2.0"
}

# ----------------------------------------------------------------------------------------------------------------------
# Domain Mapping
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_apprunner_custom_domain_association" "map" {
  service_arn = var.apprunner_service_arn
  domain_name = var.domain_name

  lifecycle {
    ignore_changes = [service_arn, domain_name]
  }
}
