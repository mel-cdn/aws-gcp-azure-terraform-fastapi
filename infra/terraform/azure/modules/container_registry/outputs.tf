output "latest_digest" {
  value = data.local_file.image_digest.content
}
