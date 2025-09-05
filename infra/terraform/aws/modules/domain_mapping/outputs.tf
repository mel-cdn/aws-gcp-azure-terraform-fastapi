output "validation_records" {
  value = aws_apprunner_custom_domain_association.domain.certificate_validation_records
}

output "dns_target" {
  value = aws_apprunner_custom_domain_association.domain.dns_target
}

output "name" {
  value = aws_apprunner_custom_domain_association.domain.domain_name
}
