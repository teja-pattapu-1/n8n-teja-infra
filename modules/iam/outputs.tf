output "cloud_run_sa_email" {
  description = "Cloud Run service account email."
  value       = google_service_account.cloud_run.email
}

output "github_actions_sa_email" {
  description = "GitHub Actions service account email."
  value       = google_service_account.github_actions.email
}

output "terraform_ci_sa_email" {
  description = "Terraform CI service account email."
  value       = google_service_account.terraform_ci.email
}

output "wif_provider" {
  description = "Workload Identity Provider resource name."
  value       = google_iam_workload_identity_pool_provider.github.name
}

output "cloud_run_sql_iam_id" {
  description = "Dependency ID for Cloud Run SQL IAM binding."
  value       = google_project_iam_member.cloud_run_sql.id
}

output "cloud_run_secrets_iam_id" {
  description = "Dependency ID for Cloud Run Secret Manager IAM binding."
  value       = google_project_iam_member.cloud_run_secrets.id
}

