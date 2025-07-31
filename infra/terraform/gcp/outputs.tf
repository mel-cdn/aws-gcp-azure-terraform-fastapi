output "docker_image_name" {
  value       = module.app_image.image_name
  description = "Docker repository name"
}

output "docker_image_location" {
  value       = module.app_image.image_location
  description = "Docker image location"
}
