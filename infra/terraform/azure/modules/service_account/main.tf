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
# User-Assigned Managed Identity for the Container App
# ----------------------------------------------------------------------------------------------------------------------
resource "azurerm_user_assigned_identity" "identity" {
  name                = "${var.resource_prefix}-aca-identity"
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = local.normalized_billing_tags
}
