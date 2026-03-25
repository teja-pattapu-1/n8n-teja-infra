locals {
  required_apis = toset([
    "artifactregistry.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "run.googleapis.com",
    "secretmanager.googleapis.com",
    "sqladmin.googleapis.com",
  ])
}

resource "google_project_service" "required" {
  for_each = local.required_apis

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "random_password" "db_password" {
  length  = 24
  special = false
}

resource "random_password" "encryption_key" {
  length  = 32
  special = false
}

module "artifact_registry" {
  source = "./modules/artifact_registry"

  project_id    = var.project_id
  location      = var.region
  repository_id = var.artifact_repository_id
  description   = "Artifact Registry for custom n8n sandbox images"

  depends_on = [google_project_service.required]
}

module "cloud_sql" {
  source = "./modules/cloud_sql"

  project_id    = var.project_id
  instance_name = var.db_instance_name
  region        = var.region
  tier          = var.db_tier
  db_name       = var.db_name
  db_user       = var.db_user
  db_password   = random_password.db_password.result

  depends_on = [google_project_service.required]
}

module "secrets" {
  source = "./modules/secrets"

  project_id     = var.project_id
  service_name   = var.service_name
  db_password    = random_password.db_password.result
  encryption_key = random_password.encryption_key.result

  depends_on = [google_project_service.required]
}

module "iam" {
  source = "./modules/iam"

  project_id        = var.project_id
  service_name      = var.service_name
  github_repo       = var.github_repo
  infra_github_repo = var.infra_github_repo

  depends_on = [google_project_service.required]
}

module "cloud_run_n8n" {
  source = "./modules/cloud_run_n8n"

  providers = {
    google      = google
    google-beta = google-beta
  }

  project_id                       = var.project_id
  region                           = var.region
  service_name                     = var.service_name
  service_account_email            = module.iam.cloud_run_sa_email
  container_image                  = var.n8n_image
  db_connection_name               = module.cloud_sql.connection_name
  db_name                          = var.db_name
  db_user                          = var.db_user
  db_password_secret_id            = module.secrets.db_password_secret_id
  encryption_key_secret_id         = module.secrets.encryption_key_secret_id
  public_base_url                  = var.public_base_url
  timezone                         = var.timezone
  min_instances                    = var.cloud_run_min_instances
  max_instances                    = var.cloud_run_max_instances
  allow_unauthenticated            = var.allow_unauthenticated
  authorized_invoker               = var.authorized_invoker
  iam_cloud_run_sql_dependency     = module.iam.cloud_run_sql_iam_id
  iam_cloud_run_secrets_dependency = module.iam.cloud_run_secrets_iam_id

  depends_on = [
    module.cloud_sql,
    module.secrets,
    module.iam,
  ]
}

