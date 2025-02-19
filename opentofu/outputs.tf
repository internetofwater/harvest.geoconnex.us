output "static_ip" {
  description = "Static IP address"
  value       = module.network.static_ip
}

output "graph_ip" {
  description = "Static IP address"
  value       = data.google_compute_instance.graphdb.network_interface[0].network_ip
}
