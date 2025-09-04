output "service_url" {
  value       = "https://${module.app_service.url}"
  description = "API service URL"
}
