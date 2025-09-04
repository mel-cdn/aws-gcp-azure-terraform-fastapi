output "url" {
  value = nonsensitive(aws_apprunner_service.service.service_url)
}
