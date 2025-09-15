terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.8.0"
    }
  }
  required_version = ">= 1.2.0"
}

locals {
  normalized_billing_tags = {
    for k, v in var.billing_tags : lower(k) => lower(v)
  }
  iam_name_prefix = "${var.resource_prefix}-${var.region}"
}

# ----------------------------------------------------------------------------------------------------------------------
# App Runner Service
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_apprunner_service" "service" {
  service_name = "${var.resource_prefix}-service"

  source_configuration {
    image_repository {
      image_identifier      = var.repo_image_latest_digest
      image_repository_type = "ECR"
      image_configuration {
        port = "8080"
        runtime_environment_variables = {
          ENVIRONMENT    = var.environment
          LOG_LEVEL      = "DEBUG"
          CLOUD_PROVIDER = "AWS"
        }
      }
    }
    auto_deployments_enabled = true
    authentication_configuration {
      access_role_arn = aws_iam_role.service_account_role.arn
    }
  }

  instance_configuration {
    cpu    = "512"
    memory = "1024"
  }

  # Public Access / No Authentication
  network_configuration {
    egress_configuration {
      egress_type = "DEFAULT"
    }
    ingress_configuration {
      is_publicly_accessible = true
    }
  }

  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.config.arn

  tags = local.normalized_billing_tags
}

# ----------------------------------------------------------------------------------------------------------------------
# Auto scaling config
# ----------------------------------------------------------------------------------------------------------------------
resource "aws_apprunner_auto_scaling_configuration_version" "config" {
  auto_scaling_configuration_name = "AutoScalingConfig"
  max_concurrency                 = 5
  min_size                        = 1
  max_size                        = 2

  tags = local.normalized_billing_tags
}
