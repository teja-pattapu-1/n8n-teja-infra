output "service_url" {
  description = "Cloud Run URL for the n8n sandbox."
  value       = module.cloud_run_n8n.uri
}

output "cloud_sql_connection_name" {
  description = "Cloud SQL connection name for the n8n database."
  value       = module.cloud_sql.connection_name
}

output "artifact_registry_repository_url" {
  description = "Artifact Registry repository URL for future custom n8n images."
  value       = module.artifact_registry.repository_url
}

output "cloud_run_service_account_email" {
  description = "Service account used by the Cloud Run n8n service."
  value       = module.iam.cloud_run_sa_email
}

output "github_actions_service_account_email" {
  description = "GitHub Actions service account for future app/image automation."
  value       = module.iam.github_actions_sa_email
}

output "terraform_ci_service_account_email" {
  description = "GitHub Actions service account for infra automation."
  value       = module.iam.terraform_ci_sa_email
}

output "wif_provider" {
  description = "Workload Identity Provider resource name."
  value       = module.iam.wif_provider
}

output "github_setup_instructions" {
  description = "Values to copy into GitHub Actions variables and secrets later."
  value       = <<-EOT
  App repo variables for ${var.github_repo}:
    GCP_PROJECT_ID=${var.project_id}
    GCP_SA_EMAIL=${module.iam.github_actions_sa_email}
    WIF_PROVIDER=${module.iam.wif_provider}
    ARTIFACT_REGISTRY_REPOSITORY=${module.artifact_registry.repository_url}

  Infra repo variables for ${var.infra_github_repo}:
    GCP_PROJECT_ID=${var.project_id}
    GCP_TERRAFORM_SA=${module.iam.terraform_ci_sa_email}
    WIF_PROVIDER=${module.iam.wif_provider}
  EOT
}
