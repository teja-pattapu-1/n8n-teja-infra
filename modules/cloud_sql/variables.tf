variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "instance_name" {
  description = "Cloud SQL instance name."
  type        = string
}

variable "region" {
  description = "GCP region for Cloud SQL."
  type        = string
}

variable "tier" {
  description = "Cloud SQL machine tier."
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

variable "db_password" {
  description = "Database user password."
  type        = string
  sensitive   = true
}

