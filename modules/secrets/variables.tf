variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "service_name" {
  description = "Base service name used in secret naming."
  type        = string
}

variable "db_password" {
  description = "n8n database password."
  type        = string
  sensitive   = true
}

variable "encryption_key" {
  description = "n8n encryption key."
  type        = string
  sensitive   = true
}

