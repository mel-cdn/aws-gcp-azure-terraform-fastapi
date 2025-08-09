output "tag" {
  value = local.image_tag
}

output "name" {
  value = data.google_artifact_registry_docker_image.image.name
}

output "upload_date" {
  value = data.google_artifact_registry_docker_image.image.upload_time
}
