# n8n-teja-infra

Terraform for a personal n8n sandbox on GCP.

## What this creates

- required GCP APIs for Cloud Run, Cloud SQL, Secret Manager, Artifact Registry, and IAM
- Artifact Registry repo for future custom n8n images
- Cloud SQL PostgreSQL 15 instance for n8n persistence
- Secret Manager secrets for the database password and `N8N_ENCRYPTION_KEY`
- Cloud Run service running a pinned n8n image
- IAM service accounts and GitHub Workload Identity Federation for `n8n-teja-workflows` and `n8n-teja-infra`

## Access model

This sandbox defaults to a private Cloud Run service. After deploy, use:

```bash
gcloud run services proxy n8n-teja --project YOUR_PROJECT_ID --region us-central1 --port 8080
```

Then open `http://127.0.0.1:8080` locally to complete the first-owner setup in n8n.

If you later want webhook-friendly public access, set `public_base_url` and optionally `allow_unauthenticated = true`, then apply again.

## First-time setup

```bash
gcloud auth application-default login
gcloud config set project YOUR_PROJECT_ID

cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars

terraform init
terraform plan
terraform apply
```

## Notes

- This uses local Terraform state for the sandbox.
- The Cloud Run service starts with a pinned n8n image from the official registry.
- The repo includes an Artifact Registry repository so you can later simulate a custom image build/deploy flow.

