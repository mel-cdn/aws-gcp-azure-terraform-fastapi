terraform {
  backend "azurerm" {
    # Will be populated on deploy or add it manually here
    resource_group_name  = ""
    storage_account_name = ""
    container_name       = ""
    key                  = ""
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.5.0"
}
