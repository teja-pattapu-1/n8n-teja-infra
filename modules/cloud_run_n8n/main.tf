terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    google-beta = {
      source = "hashicorp/google-beta"
    }
  }
}

locals {
  external_host = trim(replace(replace(var.public_base_url, "https://", ""), "http://", ""), "/")
}

resource "google_cloud_run_v2_service" "this" {
  provider = google-beta
  project  = var.project_id
  name     = var.service_name
  location = var.region

  template {
    service_account = var.service_account_email
    timeout         = "300s"

    scaling {
      min_instance_count = var.min_instances
      max_instance_count = var.max_instances
    }

    volumes {
      name = "cloudsql"
      cloud_sql_instance {
        instances = [var.db_connection_name]
      }
    }

    containers {
      name  = "n8n"
      image = var.container_image

      command = ["/bin/sh"]
      args    = ["-c", "sleep 5; n8n start"]

      resources {
        limits = {
          cpu    = "1"
          memory = "2Gi"
        }
        cpu_idle = false
      }

      ports {
        container_port = 5678
      }

      volume_mounts {
        name       = "cloudsql"
        mount_path = "/cloudsql"
      }

      env {
        name  = "N8N_PORT"
        value = "5678"
      }

      env {
        name  = "N8N_PROTOCOL"
        value = "https"
      }

      env {
        name  = "N8N_PROXY_HOPS"
        value = "1"
      }

      env {
        name  = "N8N_ENDPOINT_HEALTH"
        value = "health"
      }

      env {
        name  = "QUEUE_HEALTH_CHECK_ACTIVE"
        value = "true"
      }

      env {
        name  = "N8N_DIAGNOSTICS_ENABLED"
        value = "false"
      }

      env {
        name  = "N8N_PERSONALIZATION_ENABLED"
        value = "false"
      }

      env {
        name  = "N8N_TEMPLATES_ENABLED"
        value = "false"
      }

      env {
        name  = "N8N_PUBLIC_API_DISABLED"
        value = "true"
      }

      env {
        name  = "GENERIC_TIMEZONE"
        value = var.timezone
      }

      env {
        name  = "DB_TYPE"
        value = "postgresdb"
      }

      env {
        name  = "DB_POSTGRESDB_DATABASE"
        value = var.db_name
      }

      env {
        name  = "DB_POSTGRESDB_USER"
        value = var.db_user
      }

      env {
        name  = "DB_POSTGRESDB_HOST"
        value = "/cloudsql/${var.db_connection_name}"
      }

      env {
        name  = "DB_POSTGRESDB_PORT"
        value = "5432"
      }

      env {
        name  = "DB_POSTGRESDB_SCHEMA"
        value = "public"
      }

      dynamic "env" {
        for_each = var.public_base_url != "" ? {
          N8N_HOST            = local.external_host
          N8N_EDITOR_BASE_URL = var.public_base_url
          WEBHOOK_URL         = var.public_base_url
        } : {}

        content {
          name  = env.key
          value = env.value
        }
      }

      env {
        name = "DB_POSTGRESDB_PASSWORD"
        value_source {
          secret_key_ref {
            secret  = var.db_password_secret_id
            version = "latest"
          }
        }
      }

      env {
        name = "N8N_ENCRYPTION_KEY"
        value_source {
          secret_key_ref {
            secret  = var.encryption_key_secret_id
            version = "latest"
          }
        }
      }

      startup_probe {
        http_get {
          path = "/health"
          port = 5678
        }
        initial_delay_seconds = 30
        timeout_seconds       = 5
        period_seconds        = 15
        failure_threshold     = 10
      }

      liveness_probe {
        http_get {
          path = "/health"
          port = 5678
        }
        initial_delay_seconds = 60
        timeout_seconds       = 5
        period_seconds        = 30
        failure_threshold     = 3
      }
    }
  }

  traffic {
    percent = 100
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
  }

  depends_on = [
    var.iam_cloud_run_sql_dependency,
    var.iam_cloud_run_secrets_dependency,
  ]

  lifecycle {
    ignore_changes = [
      template[0].containers[0].image,
    ]
  }
}

resource "google_cloud_run_v2_service_iam_member" "invoker" {
  count = var.allow_unauthenticated || var.authorized_invoker != "" ? 1 : 0

  project  = google_cloud_run_v2_service.this.project
  location = google_cloud_run_v2_service.this.location
  name     = google_cloud_run_v2_service.this.name
  role     = "roles/run.invoker"
  member   = var.allow_unauthenticated ? "allUsers" : "user:${var.authorized_invoker}"
}
