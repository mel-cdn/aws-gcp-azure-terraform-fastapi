# ----------------------------------------------------------------------------------------------------------------------
# Target Container Registry
# ----------------------------------------------------------------------------------------------------------------------
data "azurerm_container_registry" "container" {
  name                = var.container_registry_name
  resource_group_name = var.resource_group_name
}

# ----------------------------------------------------------------------------------------------------------------------
# Container App permission to pull images from ACR
# ----------------------------------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "acr_pull" {
  scope                = data.azurerm_container_registry.container.id
  role_definition_name = "AcrPull"
  principal_id         = var.service_account_principal_id

  lifecycle {
    ignore_changes = [
      principal_id, scope
    ]
  }
}
