provider "google" {
  project     = var.project
  region      = var.region
  credentials = file(var.credentials) 
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

module "instances" {
  source        = "./instances"
  project       = var.project
  url           = var.url
  graph_url     = var.graph_url
  name          = var.vm_name
  zone          = var.zone
  sitemap_url   = var.sitemap_url

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
