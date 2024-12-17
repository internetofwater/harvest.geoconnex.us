variable "admin_email" {
  description = "Email of the admin user to grant access to the storage bucket"
  type        = string
  default     = "bwebb@lincolninst.edu"
}

variable "service_account_email" {
  description = "Email of the service user to access to the storage bucket"
  type        = string
  default     = "geoconnex-us@geoconnex-us.iam.gserviceaccount.com"
}

variable "project" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us"
}

variable "zone" {
  description = "GCP zone for VM deployment"
  type        = string
  default     = "us-central1-a"
}

variable "s3_bucket" {
  description = "GCP bucket name for storing data"
  type        = string
}

variable "url" {
  description = "URL Host"
  type        = string
  default     = "test.harvest.graph.internetofwater.app"
}

variable "credentials" {
  description = "Path to GCP credentials"
}

variable "vm_name" {
  description = "Name of the vm to create or use for the deployment"
  type        = string
}

variable "sitemap_url" {
  description = "URL of the sitemap index file"
  type        = string
}
