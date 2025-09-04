output "service_url" {
  value       = nonsensitive("https://${module.app_service.url}")
  description = "API service URL"
}
