variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "location" {
  description = "GCP region for Artifact Registry."
  type        = string
}

variable "repository_id" {
  description = "Artifact Registry repository ID."
  type        = string
}

variable "description" {
  description = "Artifact Registry repository description."
  type        = string
  default     = ""
}

