output "image_name" {
  value       = data.google_artifact_registry_docker_image.docker-image.image_name
  description = "Docker image name"
}

output "image_location" {
  value       = data.google_artifact_registry_docker_image.docker-image.location
  description = "Docker image location"
}

output "image_repo_id" {
  value       = data.google_artifact_registry_docker_image.docker-image.repository_id
  description = "Docker image repository"
}
