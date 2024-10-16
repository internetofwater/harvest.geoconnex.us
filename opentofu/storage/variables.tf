variable "service_account_email" {
  description = "Email of the service account to grant access to the storage bucket"
  type        = string
}

variable "project" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "s3_bucket" {
  description = "GCP bucket"
  type        = string
}
