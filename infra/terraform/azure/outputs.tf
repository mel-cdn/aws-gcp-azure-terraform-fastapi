output "resource_group_name" {
  value = azurerm_resource_group.main.name
}


# output "service_url" {
#   value       = module.app_service.url
#   description = "API service URL"
# }
#
# output "domain_url" {
#   value       = "https://${module.domain_mapping.name}"
#   description = "API service URL with domain"
# }
#
# output "dns_records" {
#   value = module.domain_mapping.dns_records
# }
