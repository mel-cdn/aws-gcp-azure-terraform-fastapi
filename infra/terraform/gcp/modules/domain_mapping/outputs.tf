output "dns_records" {
  value = google_cloud_run_domain_mapping.map.status[0].resource_records
}

output "name" {
  value = google_cloud_run_domain_mapping.map.name
}
