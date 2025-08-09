output "app_image_fq_name" {
  value       = module.app_image.name
  description = "Docker image fully qualified name"
}

output "app_image_tag" {
  value       = module.app_image.tag
  description = "Docker image tag"
}

output "service_url" {
  value       = module.app_service.url
  description = "API service URL"
}
