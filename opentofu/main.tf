provider "google" {
  project     = var.project
  region      = "us"
  credentials = file(var.credentials) 
}

resource "google_project_service" "required_apis" {
  for_each = toset([
    "compute.googleapis.com",
    "run.googleapis.com",
    "iam.googleapis.com",
    "cloudbuild.googleapis.com",
    "storage.googleapis.com",
    "servicenetworking.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ])

  project = var.project
  service = each.key

  disable_on_destroy = false
}

module "network" {
  source = "./network"
  project = var.project
}

module "storage" {
  source = "./storage"
  service_account_email = var.service_account_email
  project = var.project
  region  = var.region
  s3_bucket  = var.s3_bucket
}

module "graphdb" {
  source            = "github.com/Ontotext-AD/terraform-gcp-graphdb?ref=v0.2.3"
  source_image      = "projects/mpi-graphdb-public/global/images/ontotext-graphdb-10-7-3-202409031355"
  project_id        = var.project
  zone              = var.zone
  boot_disk_size    = 200
  network_interface = module.network.network_name
}

data "google_compute_instance" "graphdb" {
  name    = "graphdb" 
  project = var.project
  zone    = var.zone
}

module "instances" {
  source        = "./instances"
  project       = var.project
  url           = var.url
  name          = var.vm_name
  zone          = var.zone
  sitemap_url   = var.sitemap_url
  service_account_email = var.service_account_email
  graph_url     = "http://${data.google_compute_instance.graphdb.network_interface[0].network_ip}:7200"

  # notifications
  lakefs_endpoint = var.lakefs_endpoint
  lakefs_access_key = var.lakefs_access_key
  lakefs_secret_key = var.lakefs_secret_key
  dagster_slack_token = var.dagster_slack_token

  # network configurations
  network_name  = module.network.network_name
  static_ip     = module.network.static_ip

  s3_bucket     = module.storage.s3_bucket
  s3_region     = module.storage.s3_region
  s3_access_key = module.storage.s3_access_key
  s3_secret_key = module.storage.s3_secret_key
}
