variable "project_id" {
  description = "GCP project ID for the sandbox."
  type        = string
}

variable "region" {
  description = "GCP region for all resources."
  type        = string
  default     = "us-central1"
}

variable "service_name" {
  description = "Cloud Run service name."
  type        = string
  default     = "n8n-teja"
}

variable "artifact_repository_id" {
  description = "Artifact Registry repository ID for future custom n8n images."
  type        = string
  default     = "n8n-teja"
}

variable "db_instance_name" {
  description = "Cloud SQL instance name."
  type        = string
  default     = "n8n-teja-db"
}

variable "db_name" {
  description = "Postgres database name."
  type        = string
  default     = "n8n"
}

variable "db_user" {
  description = "Postgres user name."
  type        = string
  default     = "n8n_user"
}

variable "db_tier" {
  description = "Cloud SQL machine tier."
  type        = string
  default     = "db-f1-micro"
}

variable "timezone" {
  description = "n8n timezone."
  type        = string
  default     = "Asia/Kolkata"
}

variable "n8n_image" {
  description = "Pinned n8n image for the sandbox."
  type        = string
  default     = "docker.io/n8nio/n8n:1.115.2"
}

variable "github_repo" {
  description = "GitHub repo allowed to use the app deployment WIF service account."
  type        = string
  default     = "teja-pattapu-1/n8n-teja-workflows"
}

variable "infra_github_repo" {
  description = "GitHub repo allowed to use the Terraform infra WIF service account."
  type        = string
  default     = "teja-pattapu-1/n8n-teja-infra"
}

variable "cloud_run_min_instances" {
  description = "Minimum Cloud Run instances."
  type        = number
  default     = 0
}

variable "cloud_run_max_instances" {
  description = "Maximum Cloud Run instances."
  type        = number
  default     = 1
}

variable "allow_unauthenticated" {
  description = "Whether to allow public access to the Cloud Run service."
  type        = bool
  default     = true
}

variable "authorized_invoker" {
  description = "Google account email allowed to invoke the private Cloud Run service when public access is disabled."
  type        = string
  default     = ""
}

variable "public_base_url" {
  description = "Optional public base URL used for n8n editor and webhook URLs."
  type        = string
  default     = ""
}
