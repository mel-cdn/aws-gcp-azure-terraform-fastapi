output "service_url" {
  value       = "https://${module.app_service.url}"
  description = "API service URL"
}

output "domain_url" {
  description = "Custom domain URL (after DNS validation completes)"
  value       = "https://${module.domain_mapping.name}"
}

output "validation_records" {
  description = "DNS record required in your domain hosting for validation"
  value       = module.domain_mapping.validation_records
}

output "dns_target" {
  description = "DNS record required in your domain hosting for validation"
  value = {
    type  = "CNAME"
    host  = module.domain_mapping.name
    value = module.domain_mapping.dns_target
  }
}
