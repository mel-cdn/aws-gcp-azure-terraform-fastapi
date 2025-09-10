terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.5.0"
}

locals {
  normalized_billing_tags = {
    for k, v in var.billing_tags : lower(k) => lower(v)
  }
}

# ----------------------------------------------------------------------------------------------------------------------
# Log Analytics
# ----------------------------------------------------------------------------------------------------------------------
resource "azurerm_log_analytics_workspace" "log" {
  name                = "${var.resource_prefix}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = local.normalized_billing_tags
}

# ----------------------------------------------------------------------------------------------------------------------
# Container App Environment
# ----------------------------------------------------------------------------------------------------------------------
resource "azurerm_container_app_environment" "environment" {
  name                       = "${var.resource_prefix}-env"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id

  tags = local.normalized_billing_tags
}

# ----------------------------------------------------------------------------------------------------------------------
# Container App for the Service
# ----------------------------------------------------------------------------------------------------------------------
resource "azurerm_container_app" "container" {
  name                         = "${var.resource_prefix}-aca"
  resource_group_name          = var.resource_group_name
  container_app_environment_id = azurerm_container_app_environment.environment.id
  revision_mode                = "Single"

  # Application Service Account
  identity {
    type         = "UserAssigned"
    identity_ids = [var.service_account_id]
  }

  # Service Account to Pull Service Image
  registry {
    server   = data.azurerm_container_registry.container.login_server
    identity = var.service_account_id
  }

  template {
    container {
      name   = "${var.resource_prefix}-api"
      image  = var.repo_image_latest_digest
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "ENVIRONMENT"
        value = var.environment
      }
      env {
        name  = "LOG_LEVEL"
        value = "DEBUG"
      }
    }
    min_replicas = 0
    max_replicas = 2
  }

  # Public Access / No Authentication
  ingress {
    external_enabled = true
    target_port      = 8080

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  tags = local.normalized_billing_tags
}
