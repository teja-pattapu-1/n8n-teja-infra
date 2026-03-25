terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

resource "google_sql_database_instance" "this" {
  project          = var.project_id
  name             = var.instance_name
  database_version = "POSTGRES_15"
  region           = var.region

  deletion_protection = false

  settings {
    tier                        = var.tier
    availability_type           = "ZONAL"
    deletion_protection_enabled = false

    backup_configuration {
      enabled = false
    }

    ip_configuration {
      ipv4_enabled = true
    }

    database_flags {
      name  = "max_connections"
      value = "100"
    }

    insights_config {
      query_insights_enabled = false
    }
  }
}

resource "google_sql_database" "this" {
  project  = var.project_id
  name     = var.db_name
  instance = google_sql_database_instance.this.name
}

resource "google_sql_user" "this" {
  project  = var.project_id
  name     = var.db_user
  instance = google_sql_database_instance.this.name
  password = var.db_password
}
