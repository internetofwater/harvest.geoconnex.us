output "network_name" {
  description = "The name of the network"
  value       = google_compute_network.default.name
}

output "static_ip" {
  description = "Static IP address"
  value       = google_compute_address.static_ip.address
}
