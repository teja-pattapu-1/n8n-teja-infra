variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "region" {
  description = "Cloud Run region."
  type        = string
}

variable "service_name" {
  description = "Cloud Run service name."
  type        = string
}

variable "service_account_email" {
  description = "Service account email used by Cloud Run."
  type        = string
}

variable "container_image" {
  description = "Container image for the n8n service."
  type        = string
}

variable "db_connection_name" {
  description = "Cloud SQL connection name."
  type        = string
}

variable "db_name" {
  description = "Database name."
  type        = string
}

variable "db_user" {
  description = "Database user."
  type        = string
}

variable "db_password_secret_id" {
  description = "Secret Manager secret ID for the database password."
  type        = string
}

variable "encryption_key_secret_id" {
  description = "Secret Manager secret ID for the n8n encryption key."
  type        = string
}

variable "public_base_url" {
  description = "Optional public base URL for the n8n editor and webhook URLs."
  type        = string
  default     = ""
}

variable "timezone" {
  description = "n8n timezone."
  type        = string
}

variable "min_instances" {
  description = "Minimum Cloud Run instances."
  type        = number
}

variable "max_instances" {
  description = "Maximum Cloud Run instances."
  type        = number
}

variable "allow_unauthenticated" {
  description = "Whether the service should be publicly invokable."
  type        = bool
}

variable "authorized_invoker" {
  description = "Email address allowed to invoke the private service."
  type        = string
}

variable "iam_cloud_run_sql_dependency" {
  description = "Dependency value for Cloud Run SQL IAM grants."
  type        = string
}

variable "iam_cloud_run_secrets_dependency" {
  description = "Dependency value for Cloud Run Secret Manager IAM grants."
  type        = string
}

