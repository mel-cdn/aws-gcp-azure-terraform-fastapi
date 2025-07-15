output "repo_name" {
  value       = google_artifact_registry_repository.docker-image-repo.name
  description = "Docker repository name"
}
