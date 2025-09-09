output "url" {
  value = aws_ecr_repository.docker-image-repo.repository_url
}

output "image_latest_digest" {
  value = data.aws_ecr_image.latest.image_digest
}

output "arn" {
  value = aws_ecr_repository.docker-image-repo.arn
}
