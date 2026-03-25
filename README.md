# n8n-teja-infra

Terraform for a personal n8n sandbox on GCP.

## What this creates

- required GCP APIs for Cloud Run, Cloud SQL, Secret Manager, Artifact Registry, and IAM
- Artifact Registry repo for future custom n8n images
- Cloud SQL PostgreSQL 15 instance for n8n persistence
- Secret Manager secrets for the database password and `N8N_ENCRYPTION_KEY`
- Cloud Run service running a pinned n8n image
- IAM service accounts and GitHub Workload Identity Federation for `n8n-teja-workflows` and `n8n-teja-infra`

## State and delivery

- Terraform state lives in the shared GCS bucket `project-c4dba17b-b260-4522-859-tfstate` under the `n8n-teja-infra` prefix.
- Infra changes are meant to run from GitHub Actions, not from a local laptop.
- The main workflow plans on pull requests and applies on pushes to `main`.
- A separate manual workflow handles full destroys.

## GitHub Actions variables

Set these repository variables in `teja-pattapu-1/n8n-teja-infra`:

- `GCP_PROJECT_ID`
- `WIF_PROVIDER`
- `GCP_TERRAFORM_SA`

This repo is wired to reuse the same project-level GitHub federation pattern as the existing personal infra setup.

## Access model

This sandbox now defaults to a public Cloud Run service so you can open the n8n editor directly at the deployed service URL.

After the first successful deploy, if you want n8n to use a stable external URL for editor links and webhooks, set:

```hcl
public_base_url = "https://your-service-url.run.app"
```

and let GitHub Actions apply again.

## Notes

- The Cloud Run service starts with a pinned n8n image from the official registry.
- The repo includes an Artifact Registry repository so you can later simulate a custom image build/deploy flow.
