output "repo_url" {
  value = aws_ecr_repository.docker-image-repo.repository_url
}

output "repo_arn" {
  value = aws_ecr_repository.docker-image-repo.arn
}
