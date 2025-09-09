output "url" {
  value = "https://${azurerm_container_app.container.ingress[0].fqdn}"
}
