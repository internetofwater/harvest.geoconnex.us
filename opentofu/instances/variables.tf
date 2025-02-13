# instances/variables.tf

# Instance Configuration
variable "instance_os" {
  description = "Operating system for VM instances"
  type        = string
  default     = "debian-12" 
}

# Disk Configuration
variable "disk_size" {
  description = "Boot disk size for each VM instance (in GB)"
  type        = number
  default     = 100
}

variable "enable_public_url" {
  description = "Boolean if running Caddy for HTTPS"
  type        = bool
  default     = false
}

# GCP-Specific Configurations
variable "machine_type" {
  description = "Machine type for GCP instances (overrides instance_type in production)"
  type        = string
  default     = "e2-highcpu-32"
}

variable "zone" {
  description = "GCP zone for VM deployment"
  type        = string
}

variable "alert_thresholds" {
  description = "Metric thresholds for alerts (CPU, memory, storage)"
  type        = map(number)
  default     = {
    cpu     = 80,  # Alert if CPU usage exceeds 80%
    memory  = 75,  # Alert if memory usage exceeds 75%
    storage = 85   # Alert if storage usage exceeds 85%
  }
}

variable "network_name" {
  description = "Name of the network to attach the instances to"
  type        = string
}

variable "project" {
  description = "GCP project ID"
  type        = string
}

variable "static_ip" {
  description = "Static IP address"
  type        = string
}

variable "s3_bucket" {
  description = "S3 Bucket"
  type        = string
}

variable "s3_region" {
  description = "S3 Region"
  type        = string
}

variable "s3_access_key" {
  description = "S3 Access Key"
  type        = string
}

variable "s3_secret_key" {
  description = "S3 Secret Key"
  type        = string
}

variable "url" {
  description = "GCP Remote URL"
  type        = string
}

variable "graph_url" {
  description = "Graph URL"
  type        = string
}

variable "scheduler_version" {
  description = "The version of the internetofwater/scheduler to deploy."
  type        = string
  default     = "main"
}

variable "dagster_slack_token" {
  description = "Dagster slack token"
  type        = string
}

variable "name" {
  description = "The vm machine name"
  type        = string
}

variable "sitemap_url" {
  description = "URL of the sitemap index file"
  type        = string
}

variable "headless_url" {
  description = "URL of the headless service"
  type        = string
  default     = "http://scheduler_headless:9222"
}

variable "service_account_email" {
  description = "Email of the service user to access to the storage bucket"
  type        = string
}

variable "data_graph" {
  description = "name of the graph repository"
  type        = string
  default     = "iow"
}

variable "prov_graph" {
  description = "name of the prov graph repository"
  type        = string
  default     = "iowprov"
}

variable "lakefs_endpoint" {
  description = "URL of lakefs endpoint"
  type        = string
}

variable "lakefs_access_key" {
  description = "Lakefs Access Key"
  type        = string
}

variable "lakefs_secret_key" {
  description = "Lakefs Secret Key"
  type        = string
}
