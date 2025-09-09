output "container_name" {
  value = azurerm_container_registry.container.name
}

output "image_latest_tag" {
  value = local.repo_tag_latest
}

output "image_latest_digest" {
  value = jsondecode(data.local_file.image_digest.content).digest
}
