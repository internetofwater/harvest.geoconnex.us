variable "region" {
  description = "GCP region"
  type        = string
}

variable "network" {
  description = "Selflink of the network to attach the instances to"
  type        = string
}

variable "database_password" {
  description = "Password for the database user"
  type        = string
  sensitive   = true
}
