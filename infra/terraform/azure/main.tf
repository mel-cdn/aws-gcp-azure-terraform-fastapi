locals {
  billing_tags = {
    environment = var.environment
    application = var.app_name
  }
  resource_prefix = "${var.infra}-${var.app_name}-${var.environment}"
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
  repo_name           = "${var.app_name}-api"

  billing_tags = local.billing_tags
}

# ----------------------------------------------------------------------------------------------------------------------
# App Service
# ----------------------------------------------------------------------------------------------------------------------
module "app_service" {
  source                   = "./modules/container_app"
  resource_prefix          = local.resource_prefix
  environment              = var.environment
  location                 = var.location
  resource_group_name      = azurerm_resource_group.main.name
  container_registry_name  = module.app_repo.container_name
  repo_image_latest_digest = "${module.app_repo.image_latest_tag}@${module.app_repo.image_latest_digest}"

  billing_tags = local.billing_tags
  depends_on   = [module.app_repo]
}

#
# # ----------------------------------------------------------------------------------------------------------------------
# # Domain Mapping
# # ----------------------------------------------------------------------------------------------------------------------
# module "domain_mapping" {
#   source           = "./modules/domain_mapping"
#   container_app_id = module.app_service.container_app_id
#   domain_name      = "${var.environment != "prod" ? "${var.environment}." : ""}api.${var.app_name}.azure.${var.root_domain_name}"
#
#   depends_on = [module.app_service]
# }
