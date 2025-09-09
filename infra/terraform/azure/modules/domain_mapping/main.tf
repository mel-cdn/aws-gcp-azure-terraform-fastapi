terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.2.0"
}

# ----------------------------------------------------------------------------------------------------------------------
# Domain Mapping
# ----------------------------------------------------------------------------------------------------------------------
resource "azurerm_app_managed_certificate" "cert" {
  name                = "playground-dm-inventory-dev-cert"
  resource_group_name = var.resource_group_name
  domain_name         = "api.mydomain.com"
}

resource "azurerm_container_app_custom_domain" "map" {
  container_app_id                         = var.container_app_id
  name                                     = var.domain_name
  certificate_binding_type                 = "SniEnabled"
  container_app_environment_certificate_id = ""
}
