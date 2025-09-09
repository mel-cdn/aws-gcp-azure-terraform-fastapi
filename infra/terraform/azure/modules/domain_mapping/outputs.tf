output "name" {
  value = azurerm_container_app_custom_domain.map.name
}


output "certificate_validation_token" {
  value = ""
}
# output "domain_validation_record" {
#   description = "CNAME record to add in Squarespace for domain validation"
#   value = {
#     name  = azurerm_container_app_custom_domain.map.name
#     type  = "CNAME"
#     value = azurerm_container_app_custom_domain.map.validation_records
#   }
# }
