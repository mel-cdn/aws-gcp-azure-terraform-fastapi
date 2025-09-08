locals {
  billing_tags = {
    environment = var.environment
    application = var.app_name
  }
  resource_prefix = "${var.infra}-${var.app_name}-${var.environment}"


  api_name = "${var.app_name}-api"
}

provider "azurerm" {
  features {}
}

# ----------------------------------------------------------------------------------------------------------------------
# Resource Group
# ----------------------------------------------------------------------------------------------------------------------
resource "azurerm_resource_group" "main" {
  name     = "${local.resource_prefix}-rg"
  location = var.location

  tags = local.billing_tags
}

# ----------------------------------------------------------------------------------------------------------------------
# App Service Image
# ----------------------------------------------------------------------------------------------------------------------
module "app_repo" {
  source              = "./modules/container_registry"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  resource_prefix     = local.resource_prefix
  repo_name          = "${var.app_name}-api"

  billing_tags = local.billing_tags
}

# # ----------------------------------------------------------------------------------------------------------------------
# # App Cloud Run Service
# # ----------------------------------------------------------------------------------------------------------------------
# module "app_service" {
#   source          = "./modules/cloud_run_service"
#   environment     = var.environment
#   project_id      = local.project_id
#   region          = var.region
#   service_name    = local.api_name
#   service_account = google_service_account.api_service_account.email
#   container_image = "${module.app_image.tag}@${module.app_image.latest_digest}"
#
#   billing_labels = local.billing_labels
#
#   depends_on = [module.app_image]
# }
#
# # ----------------------------------------------------------------------------------------------------------------------
# # Domain Mapping
# # ----------------------------------------------------------------------------------------------------------------------
# module "domain_mapping" {
#   source                 = "./modules/domain_mapping"
#   project_id             = local.project_id
#   region                 = var.region
#   cloud_run_service_name = module.app_service.name
#   domain_name            = "${var.environment != "prod" ? "${var.environment}." : ""}api.${var.app_name}.gcp.${var.root_domain_name}"
#
#   billing_labels = local.billing_labels
#
#   depends_on = [module.app_service]
# }
