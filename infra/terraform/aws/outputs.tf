output "service_url" {
  value       = "https://${module.app_service.url}"
  description = "API service URL"
}

output "domain_url" {
  value       = "https://${module.domain_mapping.url}"
  description = "API service URL with domain"
}


output "validation_records" {
  value = module.domain_mapping.validation_records
}

output "dns_target" {
  value = module.domain_mapping.dns_target
}
