output "url" {
  value = aws_ecr_repository.docker-image-repo.repository_url
}

output "arn" {
  value = aws_ecr_repository.docker-image-repo.arn
}
