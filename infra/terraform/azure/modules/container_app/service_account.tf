# ----------------------------------------------------------------------------------------------------------------------
# Target Container Registry
# ----------------------------------------------------------------------------------------------------------------------
data "azurerm_container_registry" "container" {
  name                = var.container_registry_name
  resource_group_name = var.resource_group_name
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

# ----------------------------------------------------------------------------------------------------------------------
# Give Container App permission to pull images from ACR
# ----------------------------------------------------------------------------------------------------------------------
resource "azurerm_role_assignment" "acr_pull" {
  scope                = data.azurerm_container_registry.container.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.identity.principal_id
}
