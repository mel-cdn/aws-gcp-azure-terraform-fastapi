output "validation_records" {
  value = aws_apprunner_custom_domain_association.map.certificate_validation_records
}

output "dns_target" {
  value = aws_apprunner_custom_domain_association.map.dns_target
}

output "name" {
  value = aws_apprunner_custom_domain_association.map.domain_name
}
