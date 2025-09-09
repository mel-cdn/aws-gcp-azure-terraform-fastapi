output "service_url" {
  value       = module.app_service.url
  description = "API service URL"
}

output "domain_url" {
  value       = "https://${module.domain_mapping.name}"
  description = "API service URL with domain"
}

output "dns_records" {
  description = "DNS record required in your domain hosting for validation"
  value       = module.domain_mapping.dns_records
}
