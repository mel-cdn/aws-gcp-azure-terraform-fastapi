output "url" {
  value = "https://${azurerm_container_app.container.ingress[0].fqdn}"
}

output "container_app_id" {
  value = azurerm_container_app.container.id
}
