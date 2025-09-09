output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "service_url" {
  value       = module.app_service.url
  description = "API service URL"
}

# output "domain_url" {
#   description = "Custom domain URL (after DNS validation completes)"
#   value       = "https://${module.domain_mapping.name}"
# }
#
# output "certificate_validation_record" {
#   value = {
#     name  = "asuid.api"
#     type  = "TXT"
#     value = module.domain_mapping.certificate_validation_token
#   }
# }
