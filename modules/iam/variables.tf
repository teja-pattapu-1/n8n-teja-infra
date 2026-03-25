variable "project_id" {
  description = "GCP project ID."
  type        = string
}

variable "service_name" {
  description = "Base service name."
  type        = string
}

variable "github_repo" {
  description = "GitHub repo (owner/name) allowed to use the app CI service account."
  type        = string
}

variable "infra_github_repo" {
  description = "GitHub repo (owner/name) allowed to use the infra CI service account."
  type        = string
}

