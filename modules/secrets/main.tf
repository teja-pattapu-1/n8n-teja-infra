terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

resource "google_secret_manager_secret" "db_password" {
  project   = var.project_id
  secret_id = "${var.service_name}-db-password"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "db_password" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = var.db_password
}

resource "google_secret_manager_secret" "encryption_key" {
  project   = var.project_id
  secret_id = "${var.service_name}-encryption-key"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "encryption_key" {
  secret      = google_secret_manager_secret.encryption_key.id
  secret_data = var.encryption_key
}
