output "db_password_secret_id" {
  description = "Secret Manager secret ID for the database password."
  value       = google_secret_manager_secret.db_password.secret_id
}

output "encryption_key_secret_id" {
  description = "Secret Manager secret ID for the n8n encryption key."
  value       = google_secret_manager_secret.encryption_key.secret_id
}

