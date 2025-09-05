output "service_url" {
  value       = module.app_service.url
  description = "API service URL"
}

output "domain_url" {
  value       = "https://${module.domain_mapping.url}"
  description = "API service URL with domain"
}
