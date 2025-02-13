# network/main.tf

resource "google_compute_network" "default" {
  name                    = var.vpc_name
  auto_create_subnetworks = true
}

resource "google_compute_address" "static_ip" {
  name   = "static-ip"
  region = var.zone
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_graph" {
  name    = "allow-graph"
  network = google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports    = ["7200"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_dagster" {
  name    = "allow-dagster"
  network = google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports    = ["3000", "4000"]
  }

  source_ranges = ["0.0.0.0/0"]
}
